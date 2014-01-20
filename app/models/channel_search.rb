class ChannelSearch < BaseSearch

  def initialize(params)
    @model = Channel
    @searchfield = "name"
    super(params)
  end

end
