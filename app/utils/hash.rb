class Hash
  def recursive_transform_keys!
    transform_keys! { |k| yield(k) }
    values.each do |value|
      case value
        when Hash
          value.recursive_transform_keys! { |k| yield(k) }
        when Array
          # TODO
        else
          # nothing do
      end
    end
    self
  end
end
