defmodule R2Web.HomeController do
  use R2Web, :controller

  plug :put_root_layout, {R2Web.LayoutView, "blank.html"}

  def index(conn, _params) do
    render(conn, "index.html", error_message: nil)
  end
end
