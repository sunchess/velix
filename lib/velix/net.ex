defmodule Velix.Net do
  alias :verx,        as: Verx
  alias Velix.Client

  @xml "/root/xmlsrc/ovs_network.xml"
  @name "ovs-network"

  #virsh net-list --all
  def list do
    {:ok, ref} = connect()

    try do
      {:ok, [num_def]} = Verx.connect_num_of_defined_networks(ref)
      {:ok, [num_run]} = Verx.connect_num_of_networks(ref)

      {:ok, [shutoff]} = Verx.connect_list_defined_networks(ref, [num_def])
      {:ok, [running]} = Verx.connect_list_networks(ref, [num_run])

      {:ok, %{running: info(ref, running), shutoff: info(ref, shutoff)}}
    after 
      close(ref)
    end
  end

  def create_xml() do
    create_xml(@xml)
  end

  def create_xml(path) do
    {:ok, ref} = connect()
    try do
      {:ok, xml} = File.read(path)
      {:ok, [net]} = Verx.network_create_xml(ref, [xml])
    after
      close(ref)
    end
  end

  def remove() do
    remove(@name)
  end

  def remove(name) do
    {:ok, ref} = connect()
    try do
      {:ok, network} = lookup(ref, name)
      :ok = Verx.network_destroy(ref, [network])
      #:ok = Verx.network_undefine(ref, [network])
    after
      close(ref)
    end
  end

  #private

  defp info(ref, domains) do
    for net <- domains, into: [] do
      {:ok, {name, uuid}} = lookup(ref, net)
      {name, uuid}
    end
  end

  def lookup(ref, name) when is_binary(name) do
    {:ok, [domain]} = Verx.network_lookup_by_name(ref, [name])
    {:ok, domain}
  end

  defp connect do
    Client.connect()
  end

  defp close(ref) do
    Client.close(ref)
  end
end
