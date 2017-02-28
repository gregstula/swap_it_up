defmodule SwapItUp.PostTest do
  use SwapItUp.ModelCase

  alias SwapItUp.Post
  alias SwapItUp.Repo

  @valid_attrs %{content: "some content", flagged: true, have: "some content", posted_on: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, votes: 42, want: "some content"}
  @invalid_attrs %{}

 test "insert! post" do
    post = %Post{want: "CPU", have: "Paypal"}
    inserted_post = Repo.insert!(post)
    assert inserted_post.want == "CPU" and inserted_post.have == "Paypal"
  end

  test "insert post" do
    post = %Post{want: "SSD", have: "BTC"}
    {:ok, inserted_post} = Repo.insert(post)
    assert inserted_post.want == "SSD" and inserted_post.have == "BTC"
  end

  test "post |> insert!" do
    inserted_post = %Post{want: "Diamond Ring", have: "Google Wallet" } |> Repo.insert!
    assert inserted_post.want == "Diamond Ring" and inserted_post.have == "Google Wallet"
  end

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
