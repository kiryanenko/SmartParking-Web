class Numeric
  # Возвращает ближайшее число
  def near(a, b)
    (self - a).abs < (self - b).abs ? a : b
  end
end