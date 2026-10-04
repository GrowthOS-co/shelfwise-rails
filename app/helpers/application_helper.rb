module ApplicationHelper
  # 1699 -> "$16.99"
  def money(cents)
    number_to_currency(cents.to_d / 100)
  end

  # 2026-10-03 -> "Oct 3, 2026"
  def short_date(time)
    time.strftime("%b %-d, %Y")
  end

  # 2026-10-03 16:05 -> "Oct 3, 2026, 4:05 PM"
  def date_time(time)
    time.strftime("%b %-d, %Y, %-l:%M %p")
  end

  def status_badge(status)
    tag.span(status, class: "badge badge-#{status}")
  end
end
