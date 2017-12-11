defmodule Velix.Client do
  alias :verx_client, as: VerxClient
  alias :verx,        as: Verx

  def connect() do
    # Connect to the libvirtd socket
    {:ok, ref} = VerxClient.start()

    # libvirt remote procotol open message
    :ok = Verx.connect_open(ref)
    {:ok, ref}
  end

  def close(ref) do
    # Send a protocol close message
    :ok = Verx.connect_close(ref)

    # Close the socket
    :ok = VerxClient.stop(ref)
  end
end
