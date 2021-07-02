defmodule LoggerJSONDateTimeTest do
  use Logger.Case, async: false
  require Logger
  alias LoggerJSON.Formatters.BasicLogger

  setup do
    :ok =
      Logger.configure_backend(
        LoggerJSON,
        device: :user,
        level: nil,
        metadata: [],
        json_encoder: Jason,
        on_init: :disabled,
        formatter: BasicLogger
      )
  end

  test "date_time" do
    Logger.configure_backend(LoggerJSON, metadata: [:date_time])
    Logger.metadata(date_time: ~U[2021-07-02 15:49:17.661937Z])

    log =
      fn -> Logger.debug("hello") end
      |> capture_log()
      |> Jason.decode!()

    assert %{"date_time" => "2021-07-02T15:49:17.661937Z"} == log["metadata"]
  end
end
