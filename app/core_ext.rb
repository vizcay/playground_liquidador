class Date
  def elapsed_years_since
    now = Time.now.to_date
    now.year - self.year - ((now.month > self.month || (now.month == self.month && now.day >= self.day)) ? 0 : 1)
  end
end

