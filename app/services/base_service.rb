class BaseService
  include ActiveModel::Validations

  private

  def runs(*args)
    args.each do |method_name|
      send method_name
      if errors.present?
        # Below code acts as "ensure"
        # yield(method_name) if block_given?
        return false
      end
    end
    true
  end
end