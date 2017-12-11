defmodule Velix.Vm do
  alias :verx_client, as: VerxClient
  alias :verx,        as: Verx
  alias Velix.Client

  @xml "/root/vmsdump/test5.xml"

  def list do
    {:ok, ref} = connect()

    try do
      {:ok, [num_def]} = Verx.connect_num_of_defined_domains(ref)
      {:ok, [num_run]} = Verx.connect_num_of_domains(ref)

      {:ok, [shutoff]} = Verx.connect_list_defined_domains(ref, [num_def])
      {:ok, [running]} = Verx.connect_list_domains(ref, [num_run])

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

      # Domain is defined but not running
      {:ok, [domain]} = Verx.domain_define_xml(ref, [xml])

      # Start the VM
      :ok = Verx.domain_create(ref, [domain])

      {:ok, [active]} = Verx.connect_num_of_domains(ref)
      :io.format("Active Domains: ~p~n", [active])

      {:ok, active}
    after
      close(ref)
    end
  end

  def stop(name_or_id) do
    {:ok, ref} = connect()
    try do
      {:ok, domain} = lookup(ref, name_or_id)
      :ok = stopping(ref, domain)
      {:ok, domain}
    after
      close(ref)
    end
  end

  def remove(name_or_id) do
    {:ok, ref} = connect()

    try do
      {:ok, domain} = lookup(ref, name_or_id)
      :ok = stopping(ref, domain)

      Verx.domain_undefine(ref, [domain])
    after
      close(ref)
    end
  end

  def run(name_or_id) do
    {:ok, ref} = connect()

    try do
      {:ok, domain} = lookup(ref, name_or_id)

      if !running?(ref, domain) do
        # Start the VM
        :ok = Verx.domain_create(ref, [domain])

        {:ok, [active]} = Verx.connect_num_of_domains(ref)
        :io.format("Active Domains: ~p~n", [active])
      else
        {name, _, _} = domain
        IO.puts("Vm #{name} is running")
      end

      :ok
    after
      close(ref)
    end
  end

  # Get the domain resource
  def lookup(ref, id) when is_integer(id) do
    {:ok, [domain]} = Verx.domain_lookup_by_id(ref, [id])
    {:ok, domain}
  end

  def lookup(ref, name) when is_binary(name) do
    {:ok, [domain]} = Verx.domain_lookup_by_name(ref, [name])
    {:ok, domain}
  end

#private
  
  defp running?(ref, domain) do
    {:ok, [num_run]} = Verx.connect_num_of_domains(ref)
    {:ok, [running]} = Verx.connect_list_domains(ref, [num_run])
    {_, _, id} = domain

    Enum.member?(running, id)
  end

  defp stopping(ref, domain) do
    if running?(ref, domain) do
      # shutdown only works if acpid is installed in the VM
      :ok = Verx.domain_shutdown(ref, [domain])
      :ok = Verx.domain_destroy(ref, [domain])
    else
      {name, _, _} = domain
      IO.puts("Vm #{name} is not running")
    end
    :ok
  end

  defp info(ref, domains) do
    for domain <- domains, into: [] do
      {:ok, {name, uuid, id}} = lookup(ref, domain)
      {name, uuid, id}
    end
  end

  defp connect do
    Client.connect()
  end

  defp close(ref) do
    Client.close(ref)
  end
end
