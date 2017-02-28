defmodule SwapItUp.MarketView do
  use SwapItUp.Web, :view

  def make_title(post) do
    if post.buying do
      post.want <> post.have
    else
      post.have <> post.want
    end
  end
end
