using Images, Colors, ColorSchemes

function get_steps(z::Complex, c::Complex, max_steps)
    # z = Complex(0.0, 0.0) # complex num z = 0 + 0im
    for i = 1:max_steps # 1 to max_steps
        z = z * z + c 
        if abs(z) > 2 # |z| > 2, stop the calculation
            return i
        end
    end
    return max_steps+1 #in a set
end

function get_color(colorscheme, step, max_steps)
    #=
    If the point did not diverge (i.e., it did not exceed the maximum number of steps), set the color to black (within the set)
    =#
    if step == max_steps + 1
        return [0,0,0]
    end
    ## when diverge, dicide the color between 1 to max_steps
    color = get(colorscheme, step, (1, max_steps)) 
    return [color.r, color.g, color.b]
end

function julia_plot(c::Complex; width=2400, height=1600, max_steps=100, colorscheme=ColorSchemes.inferno)

    #range for real values
    cr_min = -2.0
    cr_max = 2
    #adj the position of the set
    ci_min = -1.5
    dot_size = (cr_max - cr_min) / width 
    ci_max = ci_min + height * dot_size

    #=
    image[1, 1, 1]  # Red (R) channel value of the first pixel
    image[2, 1, 1]  # Green (G) channel value of the first pixel
    image[3, 1, 1]  # Blue (B) channel value of the first pixel
    image[1, 1, 2]  # Red (R) channel value of the second pixel
    =#
    # Set the RGB values for the pixel at position (y, x)
    # 3×800×1000 Array
    image = zeros(Float64, (3, height, width)) 

    # Initialize x and y for tracking pixel coordinates in the image
    x,y = 1,1
    #julia slicing is "start:skip:stop"
    for ci = ci_min:dot_size:ci_max - dot_size #x-axis
        x = 1
        for cr = cr_min:dot_size:cr_max - dot_size #y-axis
            z = Complex(cr, ci)
            steps = get_steps(z, c, max_steps)
            colors = get_color(colorscheme, steps, max_steps)
            image[:, y, x] = colors
            x += 1
        end
        y += 1
    end

    save("julia_set.bmp", colorview(RGB, image))
end

print("Enter the real part of c: ")
real_c = parse(Float64, readline())

print("Enter the imaginary part of c: ")
imag_c = parse(Float64, readline())

c = Complex(real_c, imag_c)

julia_plot(c)