defmodule Deditex.Address do
  # Package headers
  defmacro send_header, do: <<0x63, 0x9A, 0x01>>
  defmacro response_header, do: <<0x63, 0x9A, 0x81>>
  # End Package Headers

  # Digital Inputs
  defmacro inputs, do: <<0x00, 0x20>>
  defmacro inputs_ff, do: <<0x00, 0x40>>
  defmacro inputs_count, do: <<0x01, 0x00>>
  defmacro inputs_count_reset, do: <<0x02, 0x00>>
  defmacro num_inputs, do: <<0xFF, 0x02>>
  # End Digital Inputs

  # Digital Outputs
  defmacro outputs, do: <<0x00, 0x00>>
  defmacro num_outputs, do: <<0xFF, 0x00>>
  # End Digital Outputs

  # Analog Inputs
  defmacro analog_inputs, do: <<0x10, 0x00>>
  defmacro num_analog_inputs, do: <<0xFF, 0x08>>
  # End Analog Inputs

  # Analog Outputs
  defmacro analog_outputs, do: <<0x20, 0x00>>
  defmacro num_analog_outputs, do: <<0xFF, 0x06>>
  # End Analog Outputs

  # Temperature Inputs
  defmacro temp_inputs, do: <<0x40, 0x00>>
  defmacro num_temp_inputs, do: <<0xFF, 0x10>>
  # End Temperature Inputs

  # Pulse Outputs
  defmacro pulse_outputs, do: <<0x58, 0x00>>
  defmacro num_pulse_outputs, do: <<0xFF, 0x14>>
  # End Pulse Outputs

  # Steppers
  defmacro steppers, do: <<0x30, 0x00>>
  defmacro num_steppers, do: <<0xFF, 0x0A>>
  # End Steppers

  defmacro num_inoutputs, do: <<0xFF, 0x04>>

  defmacro num_input_counters, do: <<0xFF, 0x0E>>

  # 48Bit
  defmacro bit48_inputs, do: <<0x50, 0x00>>
  defmacro num_bit48_inputs, do: <<0xFF, 0x12>>

  # PWM Outputs
  defmacro pwm_outputs, do: <<0x08, 0x00>>
  defmacro num_pwm_outputs, do: <<0xFF, 0x16>>
  # End PWM Outputs
end
