# f_pwm = f_clk / ( N x 2 x top)
# top = f_clk / (f_pwm x 2 x N)
N = (
    1,
    8,
    64,
    256,
    1024
)  # #
f_clk = 8e6  # Hz
f_pwm = 50  # Hz

for n in N:
    top = round(f_clk / (f_pwm * 2 * n))
    top = min(top, 0xFF)
    top = max(top, 0x00)
    new_f_pwm = f_clk / (n * 2 * top)  # Hz
    new_period = 1 / new_f_pwm  # s
    new_step = new_period / top
    print(
        f"N = {n:4d}  "
        f"top = 0x{top:02X}  "
        f"f_PWM = {round(new_f_pwm):6} Hz  "
        f"T_PWM = {round(new_period * 1e3):6} ms  "
        f"step = {round(new_step * 1e6):6} us  "
    )
