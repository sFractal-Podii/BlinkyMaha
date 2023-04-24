defmodule Mqtt.Command do
  @moduledoc """
  Documentation for `Command` contains helper functions for decoding
  and responding to OpenC2 cmds:
  - new - initialize struct and validate command
  - do_cmd - execute the command
  - return_result - respond to OC2 producer
  """

  require Logger

  @doc """
  return result
  """
  def return_result(%Oc2.Command{error?: true} = command) do
    ## something went wrong upstream, so return "oops"
    e1 = "Error: "
    e2 = inspect(command.error_msg)
    error_msg = e1 <> " " <> e2
    Logger.debug(error_msg)
    Tortoise.publish("sFractal/response", "oops")
    {:error, error_msg}
  end

  def return_result(%Oc2.Command{response: nil} = command) do
    ## no response
    {:ok, command}
  end

  def return_result(command) do
    client_id = System.get_env("CLIENT_ID")
    IO.inspect(client_id, label: "==========================")
    Logger.debug("return: ok #{inspect(command.response)}")
    response = Jason.encode(command.response)
    Logger.debug("json: #{inspect(response)}")

    command = """
    {"action": "query", 
    "target": {"x-sfractal-blinky:hello_world": "Hello"},
    "args": {"response_requested": "complete"}
    }
    """

    Tortoise.publish(client_id, "sFractal/response", command)
    |> IO.inspect(label: "----------------command")

    {:ok, command}
  end
end

# 1. How are we supposed to publish on the raspberry pi
# 2. What will be our broker now that we are using rpi
