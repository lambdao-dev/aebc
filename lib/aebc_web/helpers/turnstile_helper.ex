defmodule AebcWeb.TurnstileHelper do
  @moduledoc """
  Helper functions for Cloudflare Turnstile integration.
  """

  use Tesla

  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.JSON

  @doc """
  Validates a Turnstile token by sending it to Cloudflare's verification endpoint.
  """
  def verify_token(token, remote_ip) when is_binary(token) and is_binary(remote_ip) do
    secret_key = Application.get_env(:aebc, :turnstile)[:secret_key]

    payload = %{
      "secret" => secret_key,
      "response" => token,
      "remoteip" => remote_ip
    }

    case post("https://challenges.cloudflare.com/turnstile/v0/siteverify", payload) do
      {:ok, %Tesla.Env{status: 200, body: %{"success" => true} = response}} ->
        {:ok, response}
      {:ok, %Tesla.Env{status: 200, body: %{"success" => false, "error-codes" => error_codes}}} ->
        {:error, "Turnstile verification failed: #{Enum.join(error_codes, ", ")}"}
      {:ok, %Tesla.Env{status: 200, body: _}} ->
        {:error, "Invalid Turnstile response"}
      {:ok, %Tesla.Env{status: status_code}} ->
        {:error, "Turnstile verification failed with status code: #{status_code}"}
      {:error, reason} ->
        {:error, "Turnstile verification request failed: #{inspect(reason)}"}
    end
  end

  @doc """
  Validates a Turnstile token without remote IP (for cases where IP is not available).
  """
  def verify_token(token) when is_binary(token) do
    secret_key = Application.get_env(:aebc, :turnstile)[:secret_key]

    payload = %{
      "secret" => secret_key,
      "response" => token
    }

    case post("https://challenges.cloudflare.com/turnstile/v0/siteverify", payload) do
      {:ok, %Tesla.Env{status: 200, body: %{"success" => true} = response}} ->
        {:ok, response}
      {:ok, %Tesla.Env{status: 200, body: %{"success" => false, "error-codes" => error_codes}}} ->
        {:error, "Turnstile verification failed: #{Enum.join(error_codes, ", ")}"}
      {:ok, %Tesla.Env{status: 200, body: _}} ->
        {:error, "Invalid Turnstile response"}
      {:ok, %Tesla.Env{status: status_code}} ->
        {:error, "Turnstile verification failed with status code: #{status_code}"}
      {:error, reason} ->
        {:error, "Turnstile verification request failed: #{inspect(reason)}"}
    end
  end
end
