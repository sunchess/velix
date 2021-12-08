# Velix

Elixir wrapper for [verx](https://github.com/msantos/verx) package 

## Installation

From packages by adding `velix` to dependencies list `mix.exs`:

```elixir
def deps do
  [
    {:velix, "~> 0.1.0"}
  ]
end
```

## Examples

```
git clone https://github.com/sunchess/velix.git

cd velix

mix deps.get
mix deps.compile
iex -S mix
```

### Retrive virtual machines

```elixir
Velix.Vm.list

{:ok,
 %{
   running: [
     {"one-61",
      <<219, 177, 187, 102, 214, 22, 77, 2, 175, 135, 87, 105, 193, 78, 17, 61>>,
      6},
     {"one-69",
      <<37, 14, 249, 61, 43, 60, 64, 106, 179, 120, 172, 89, 19, 102, 238, 101>>,
      10},
     {"one-57",
      <<213, 198, 142, 92, 107, 184, 78, 205, 182, 130, 250, 212, 235, 67, 184,
        51>>, 5},
     {"one-65",
      <<250, 129, 29, 199, 127, 252, 68, 47, 161, 44, 243, 65, 140, 63, 218,
        78>>, 11},
     {"one-73",
      <<136, 111, 76, 103, 246, 239, 72, 4, 151, 29, 144, 66, 3, 121, 253, 191>>,
      12},
     {"one-60",
      <<214, 17, 150, 131, 186, 172, 69, 198, 147, 65, 93, 183, 46, 212, 250,
        197>>, 7}
   ],
   shutoff: []
 }}
```

### Create a virtural machine from XML file

```elixir
# if you have path to xml /root/vmsdump/test5.xml

Velix.Vm.create_xml

#or

Velix.Vm.create_xml("path/to/xml")

Active Domains: 7
{:ok, 7}

Velix.Vm.list
{:ok,
 %{
   running: [
     {"one-61",
      <<219, 177, 187, 102, 214, 22, 77, 2, 175, 135, 87, 105, 193, 78, 17, 61>>,
      6},
     {"one-69",
      <<37, 14, 249, 61, 43, 60, 64, 106, 179, 120, 172, 89, 19, 102, 238, 101>>,
      10},
     {"one-57",
      <<213, 198, 142, 92, 107, 184, 78, 205, 182, 130, 250, 212, 235, 67, 184,
        51>>, 5},
     {"one-65",
      <<250, 129, 29, 199, 127, 252, 68, 47, 161, 44, 243, 65, 140, 63, 218,
        78>>, 11},
     {"one-73",
      <<136, 111, 76, 103, 246, 239, 72, 4, 151, 29, 144, 66, 3, 121, 253, 191>>,
      12},
     {"one-60",
      <<214, 17, 150, 131, 186, 172, 69, 198, 147, 65, 93, 183, 46, 212, 250,
        197>>, 7},
     {"one-666",
      <<97, 205, 203, 18, 222, 118, 17, 231, 128, 193, 154, 33, 76, 240, 147,
        174>>, 18}
   ],
   shutoff: []
 }}
```

### The identifier argument is virtual machine's id or name 

### Stop a virtual machine.

```elixir
Velix.Vm.stop("one-666")
{:ok,
 {"one-666",
  <<97, 205, 203, 18, 222, 118, 17, 231, 128, 193, 154, 33, 76, 240, 147, 174>>,
  18}}

Velix.Vm.list
{:ok,
 %{
   running: [
     {"one-61",
      <<219, 177, 187, 102, 214, 22, 77, 2, 175, 135, 87, 105, 193, 78, 17, 61>>,
      6},
     {"one-69",
      <<37, 14, 249, 61, 43, 60, 64, 106, 179, 120, 172, 89, 19, 102, 238, 101>>,
      10},
     {"one-57",
      <<213, 198, 142, 92, 107, 184, 78, 205, 182, 130, 250, 212, 235, 67, 184,
        51>>, 5},
     {"one-65",
      <<250, 129, 29, 199, 127, 252, 68, 47, 161, 44, 243, 65, 140, 63, 218,
        78>>, 11},
     {"one-73",
      <<136, 111, 76, 103, 246, 239, 72, 4, 151, 29, 144, 66, 3, 121, 253, 191>>,
      12},
     {"one-60",
      <<214, 17, 150, 131, 186, 172, 69, 198, 147, 65, 93, 183, 46, 212, 250,
        197>>, 7}
   ],
   shutoff: [
     {"one-666",
      <<97, 205, 203, 18, 222, 118, 17, 231, 128, 193, 154, 33, 76, 240, 147,
        174>>, -1}
   ]
 }}
```

### Run a virtual machine

```elixir
Velix.Vm.run("one-666")
Active Domains: 7
:ok
```

## Remove a virtual machine

```elixir
Velix.Vm.remove("one-666")
:ok
```

## Networks

### Retrive networks

```elixir
Velix.Net.list
{:ok,
 %{
   running: [
     {"default",
      <<61, 156, 232, 239, 226, 81, 77, 0, 156, 41, 125, 64, 107, 73, 240, 209>>}
   ],
   shutoff: []
 }}
```

### Create a network from xml

```elixir
Velix.Net.create_xml("path/to/xml")
{:ok,
 [
   {"ovs-network",
    <<103, 92, 185, 11, 103, 229, 67, 132, 157, 143, 14, 194, 93, 206, 68, 45>>}
 ]}

Velix.Net.list
{:ok,
 %{
   running: [
     {"default",
      <<61, 156, 232, 239, 226, 81, 77, 0, 156, 41, 125, 64, 107, 73, 240, 209>>},
     {"ovs-network",
      <<103, 92, 185, 11, 103, 229, 67, 132, 157, 143, 14, 194, 93, 206, 68,
        45>>}
   ],
   shutoff: []
 }}
```

### Remove a network

```elixir
Velix.Net.remove
:ok

 Velix.Net.list
{:ok,
 %{
   running: [
     {"default",
      <<61, 156, 232, 239, 226, 81, 77, 0, 156, 41, 125, 64, 107, 73, 240, 209>>}
   ],
   shutoff: []
}}
```
