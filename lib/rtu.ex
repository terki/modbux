defmodule Modbus.Rtu do
  alias Modbus.Helper
  alias Modbus.Request
  alias Modbus.Response
  @moduledoc false

  def pack_req(cmd) do
    cmd |> Request.pack |> wrap
  end

  def parse_req(wraped) do
    wraped |> unwrap |> Request.parse
  end

  def pack_res(cmd, values) do
    cmd |> Response.pack(values) |> wrap
  end

  def parse_res(cmd, wraped) do
    Response.parse(cmd, wraped |> unwrap)
  end

  def wrap(payload) do
    crc = Helper.crc(payload)
    <<payload::binary, crc::16>>
  end

  def unwrap(data) do
    size = :erlang.byte_size(data)-2
    <<payload::binary-size(size), crc::16>> = data
    ^crc = Helper.crc(payload)
    payload
  end

end