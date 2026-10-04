# Replaces everything in the database with the sample shop below. Order times
# are relative to now, so the newest order is always from today. Run with
# `bin/rails db:seed`.

# [title, author, genre, published year, price in cents, stock, ISBN, description]
books = [
  [ "The Lantern Keeper's Daughter", "Clara Whitlow", "Fiction", 2021, 1699, 12, "9781999900014", "A lighthouse keeper's daughter inherits the light and a box of unsent letters." ],
  [ "Salt and Saffron", "Rafael Okoye", "Fiction", 2019, 1499, 8, "9781999900021", "Two rival cooks share one small kitchen for a summer." ],
  [ "A Year Without Winter", "Ingrid Solberg", "Fiction", 2023, 2199, 5, "9781999900038", "A northern town waits for snow that never comes." ],
  [ "The Quiet Orchard", "Hannah Mercer", "Fiction", 2018, 1299, 0, "9781999900045", "Three sisters return to sell the family orchard." ],
  [ "Paper Boats", "Dev Malhotra", "Fiction", 2022, 1599, 20, "9781999900052", "Childhood friends reunite in the city where they grew up." ],
  [ "Tidewater", "June Calloway", "Fiction", 2020, 1799, 3, "9781999900069", "A ferry captain's last season on the river." ],
  [ "The Ninth Locker", "Marcus Hale", "Mystery", 2021, 1399, 15, "9781999900076", "A key found in a library book opens a locker no one has rented." ],
  [ "Death at Low Tide", "Agnes Pryor", "Mystery", 2017, 1199, 9, "9781999900083", "A body on the sandbar and only one set of footprints." ],
  [ "The Cartographer's Alibi", "Simone Duval", "Mystery", 2022, 1899, 6, "9781999900090", "A mapmaker swears she was somewhere that does not exist." ],
  [ "Cold Case at Fern Hollow", "Peter Lindqvist", "Mystery", 2019, 1299, 2, "9781999900106", "A retired detective reopens the case that ended his career." ],
  [ "Silent Bell", "Okonkwo Adeyemi", "Mystery", 2023, 2099, 11, "9781999900113", "The church bell stops ringing the night the organist vanishes." ],
  [ "The Last Train to Halden", "Ruth Ellery", "Mystery", 2020, 1499, 0, "9781999900120", "Six passengers, one stalled train, and a missing ticket." ],
  [ "Small Worlds: A Field Guide to Microbes", "Elena Ruiz", "Science", 2021, 2499, 7, "9781999900137", "The tiny life all around us, with photographs and simple experiments." ],
  [ "The Shape of Time", "Arjun Sen", "Science", 2018, 2299, 4, "9781999900144", "How clocks, planets and physics agree on what a second is." ],
  [ "Rivers of Air", "Molly Hargreaves", "Science", 2022, 1999, 10, "9781999900151", "The winds and currents that carry weather around the world." ],
  [ "Why Bridges Stand", "Tomas Novak", "Science", 2020, 2699, 5, "9781999900168", "The engineering behind ten famous bridges." ],
  [ "The Clever Octopus", "Fiona Banks", "Science", 2023, 1799, 14, "9781999900175", "What scientists have learned about how octopuses think." ],
  [ "Counting the Stars", "Kenji Mori", "Science", 2019, 2199, 1, "9781999900182", "A short history of measuring the night sky." ],
  [ "The Spice Roads", "Leila Nasser", "History", 2020, 2899, 6, "9781999900199", "Traders, ports and the routes that carried pepper and cinnamon." ],
  [ "Empire of Clay", "Victor Hume", "History", 2017, 2499, 3, "9781999900205", "The rise and fall of an ancient kingdom of potters." ],
  [ "Harbor Lights: A History of Lighthouses", "Grace Okafor", "History", 2021, 1999, 8, "9781999900212", "Two thousand years of keeping ships off the rocks." ],
  [ "The Printer's Revolution", "Samuel Wren", "History", 2018, 2299, 9, "9781999900229", "How cheap printing changed who could read and what they read." ],
  [ "Letters from the Front", "Anne Delacroix", "History", 2022, 1899, 12, "9781999900236", "Ordinary soldiers' letters home, collected and explained." ],
  [ "Cities Under Sand", "Hamid Rahimi", "History", 2023, 2699, 4, "9781999900243", "Desert cities lost and found again by archaeologists." ]
]

# items are [book number (1-24), quantity]. The stock above is already what is
# left after these orders, so seeding does not take it out again.
orders = [
  { customer_name: "Ben Turner", email: "ben.turner@example.com", shipping_address: "14 Elm Street\nSpringfield, IL 62704",
    placed_ago: 9.days, shipped_ago: 7.days, items: [ [ 1, 1 ], [ 13, 1 ] ] },
  { customer_name: "Mira Shah", email: "mira.shah@example.com", shipping_address: "88 Harbor Road\nPortland, ME 04101",
    placed_ago: 2.days, items: [ [ 7, 2 ] ] },
  { customer_name: "Carlos Mendes", email: "carlos.mendes@example.com", shipping_address: "301 Pine Avenue, Apt 4B\nAustin, TX 78701",
    placed_ago: 3.hours, items: [ [ 19, 1 ], [ 5, 1 ], [ 17, 1 ] ] }
]

now = Time.current

ActiveRecord::Base.transaction do
  OrderItem.delete_all
  Order.delete_all
  CartItem.delete_all
  Cart.delete_all
  Book.delete_all
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence")

  records = books.map do |title, author, genre, published_year, price_cents, stock, isbn, description|
    Book.create!(title:, author:, genre:, published_year:, price_cents:, stock:, isbn:, description:)
  end

  orders.each do |sample|
    Order.create!(
      customer_name: sample[:customer_name],
      email: sample[:email],
      shipping_address: sample[:shipping_address],
      created_at: now - sample[:placed_ago],
      status: sample[:shipped_ago] ? :shipped : :placed,
      shipped_at: sample[:shipped_ago] && now - sample[:shipped_ago],
      items: sample[:items].map do |number, quantity|
        book = records[number - 1]
        OrderItem.new(book:, title: book.title, unit_price_cents: book.price_cents, quantity:)
      end
    )
  end
end

puts "Seeded #{books.size} books and #{orders.size} orders."
