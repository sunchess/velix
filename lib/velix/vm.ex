defmodule Velix.Vm do
  alias :verx_client, as: VerxClient
  alias :verx,        as: Verx
  @xml "/root/vmsdump/test5.xml"

  def list do
    {:ok, ref} = VerxClient.start()
    :ok = Verx.connect_open(ref)

    {:ok, [num_def]} = Verx.connect_num_of_defined_domains(ref)
    {:ok, [num_run]} = Verx.connect_num_of_domains(ref)

    {:ok, [shutoff]} = Verx.connect_list_defined_domains(ref, [num_def])
    {:ok, [running]} = Verx.connect_list_domains(ref, [num_run])

    {:ok, %{running: info(ref, running), shutoff: info(ref, shutoff)}}
  end

  def create_xml() do
    create_xml(@xml)
  end

  def create_xml(path) do
    # Connect to the libvirtd socket
    {:ok, ref} = VerxClient.start()

    # libvirt remote procotol open message
    :ok = Verx.connect_open(ref)

    {:ok, xml} = File.read(path)

    # Domain is defined but not running
    {:ok, [domain]} = Verx.domain_define_xml(ref, [xml])

    # Start the VM
    :ok = Verx.domain_create(ref, [domain])

    {:ok, [active]} = Verx.connect_num_of_domains(ref)
    :io.format("Active Domains: ~p~n", [active])

    # Send a protocol close message
    :ok = Verx.connect_close(ref)

    # Close the socket
    :ok = VerxClient.stop(ref)

    {:ok, domain}
  end



  defp info(ref, domains) do
    for domain <- domains, into: [] do
      {:ok, [{name, uuid, id}]} = Verx.domain_lookup_by_id(ref, [domain])
      {name, uuid, id}
    end
  end

end
