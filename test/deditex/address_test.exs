defmodule DeditexAddressTest do
  use ExUnit.Case, async: true
  require Deditex.Address
  alias Deditex.Address

  test "Headers" do
    assert <<0x63, 0x9A, 0x01>> = Address.send_header()
    assert <<0x63, 0x9A, 0x81>> = Address.response_header()
  end

  test "Digital Inputs" do
    assert <<0x00, 0x20>> = Address.inputs()
    assert <<0x00, 0x40>> = Address.inputs_ff()
    assert <<0x01, 0x00>> = Address.inputs_count()
    assert <<0x02, 0x00>> = Address.inputs_count_reset()
    assert <<0xFF, 0x02>> = Address.num_inputs()
  end

  test "Digital Outputs" do
    assert <<0x00, 0x00>> = Address.outputs()
    assert <<0xFF, 0x00>> = Address.num_outputs()
  end

  test "Analog Inputs" do
    assert <<0x10, 0x00>> = Address.analog_inputs()
    assert <<0xFF, 0x08>> = Address.num_analog_inputs()
  end

  test "Analog Outputs" do
    assert <<0x20, 0x00>> = Address.analog_outputs()
    assert <<0xFF, 0x06>> = Address.num_analog_outputs()
  end

  test "Temperature Inputs" do
    assert <<0x40, 0x00>> = Address.temp_inputs()
    assert <<0xFF, 0x10>> = Address.num_temp_inputs()
  end

  test "Pulse Outputs" do
    assert <<0x58, 0x00>> = Address.pulse_outputs()
    assert <<0xFF, 0x14>> = Address.num_pulse_outputs()
  end

  test "Steppers" do
    assert <<0x30, 0x00>> = Address.steppers()
    assert <<0xFF, 0x0A>> = Address.num_steppers()
  end

  test "In/Outputs" do
    assert <<0xFF, 0x04>> = Address.num_inoutputs()
  end

  test "Input Counters" do
    assert <<0xFF, 0x0E>> = Address.num_input_counters()
  end

  test "48Bit" do
    assert <<0x50, 0x00>> = Address.bit48_inputs()
    assert <<0xFF, 0x12>> = Address.num_bit48_inputs()
  end

  test "PWM Outputs" do
    assert <<0x08, 0x00>> = Address.pwm_outputs()
    assert <<0xFF, 0x16>> = Address.num_pwm_outputs()
  end
end
