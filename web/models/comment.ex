defmodule SwapItUp.Comment do
  use SwapItUp.Web, :model

  schema "comments" do
    field :content, :string
    
    belongs_to :post, SwapItUp.Post

    timestamps
  end
end
