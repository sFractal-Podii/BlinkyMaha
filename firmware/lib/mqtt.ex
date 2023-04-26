defmodule Mqtt do
  @moduledoc """
  `Mqtt` is main module for handling mqtt
  mqtt.start initializes the system
     and starts the Tortoise mqtt client using mqtt.handler
  """

  require Logger

  @doc """
  Start initializes system variables
  and starts supervisor of mqtt client
  """
  def start do
    client_id =
      Application.get_env(:firmware, :client_id) ||
        raise """
        environment variable CLIENT_ID is missing.
        For example:
        export CLIENT_ID=:sfractal2020
        """

    Logger.info("client_id is #{client_id}")

    mqtt_host =
      Application.get_env(:firmware, :mqtt_host) ||
        raise """
        environment variable HOST is missing.
        Examples:
        export MQTT_HOST="35.221.11.97 "
        export MQTT_HOST="mqtt.sfractal.com"
        """

    Logger.info("mqtt_host is #{mqtt_host}")

    mqtt_port =
        Application.get_env(:firmware, :mqtt_port) ||
          raise("""
          environment variable MQTT_PORT is missing.
          Example:
          export MQTT_PORT=1883
          """)

    Logger.info("mqtt_port is #{mqtt_port}")

    server = {Tortoise.Transport.Tcp, host: mqtt_host, port: mqtt_port}

    user_name =
      Application.get_env(:firmware, :user_name) ||
        raise """
        environment variable USER_NAME is missing.
        Examples:
        export USER_NAME="plug"
        """

    Logger.info("user_name is #{user_name}")

    password =
      Application.get_env(:firmware, :password) ||
        raise """
        environment variable PASSWORD is missing.
        Example:
        export PASSWORD="fest"
        """

    Logger.info("password set")

    {:ok, _pid} =
      Tortoise.Supervisor.start_child(
        Oc2Mqtt.Connection.Supervisor,
        client_id: client_id,
        handler: {Mqtt.Handler, [name: client_id]},
        server: server,
        user_name: user_name,
        password: password,
        subscriptions: [{"sfractal/command", 0}, {"sfractal/response", 0}]
      )
  end
end
