defmodule ClientCertWork do
  @moduledoc """
  Documentation for `ClientCertWork`.
  """

  def finch_get do
    Finch.start_link(name: MyFinch, pools: %{
      default: [conn_opts: [transport_opts: [certfile: 'badssl.com-client.pem', password: 'badssl.com']]]
    })
    req = Finch.build(
      :get,
      "https://client.badssl.com",
      [],
      nil,
      []
    )
    {:ok, _resp} = Finch.request(req, MyFinch)
  end

  def mojito_get do
    {:ok, _resp} = Mojito.get("https://client.badssl.com", [], transport_opts: [certfile: 'badssl.com-client.pem', password: 'badssl.com'])
  end

  def mint_get do
    {:ok, conn} = Mint.HTTP.connect(:https, "client.badssl.com", 443, transport_opts: [certfile: 'badssl.com-client.pem', password: 'badssl.com'])
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "GET", "/", [], nil)
    receive do
      message ->
        {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
        IO.inspect responses
    end
  end
end
