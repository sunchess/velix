defmodule Velix.Vm do
  alias :verx_client, as: VerxClient
  alias :verx,        as: Verx

  def list do
    {:ok, ref} = VerxClient.start()
    :ok = Verx.connect_open(ref)

    {:ok, [num_def]} = Verx.connect_num_of_defined_domains(ref)
    {:ok, [num_run]} = Verx.connect_num_of_domains(ref)

    {:ok, [shutoff]} = Verx.connect_list_defined_domains(ref, [num_def])
    {:ok, [running]} = Verx.connect_list_domains(Ref, [num_run])

    {:ok, [{running, info(ref, running)},
             {shutoff, info(ref, shutoff)}]}
  end



  def info(ref, domains) do
    {:ok, [{name, uuid, id}]} = Verx.domain_lookup_by_id(ref)
    {:name, [{:uuid, uuid}, {:id, id}]}
  end

end
