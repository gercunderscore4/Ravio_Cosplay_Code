from math import ceil
from numpy import linspace, cos, sin, arccos, arcsin, radians, degrees
import matplotlib.pyplot as plt
from typing import NamedTuple


THETA = linspace(0, 360, 20)


class RingRadii(NamedTuple):
    """ For storing annulus (basically a ring) radii """
    inner: float
    outer: float
    base: float
    height: float


def cosd(theta):
    return cos(radians(theta))


def sind(theta):
    return sin(radians(theta))


def arccosd(x):
    return degrees(arccos(x))


def arcsind(y):
    return degrees(arcsin(y))


def get_even_rings(
        outer_diameter=10,
        wall_thickness=1,
        material_height=1,
        stop_angle=70, # 90 would be a sphere, 1 would be a annulus
        allowance=0.25,
    ):
    """
    Calculate ring layers needed to form a hollow sphere.
    Use an even number of layers (rings start from the mid-plane)
    """
    # calculated
    inner_diameter = outer_diameter - (2 * wall_thickness)
    sphere_inner_radius = inner_diameter / 2
    sphere_outer_radius = outer_diameter / 2

    # make list of only upper rings
    count = ceil(sphere_outer_radius / material_height)
    ring_list = []
    for i in range(count):
        base_height = material_height * i
        base_angle = arcsind(base_height / sphere_outer_radius)
        peak_height = base_height + material_height
        if peak_height < sphere_outer_radius:
            peak_angle = arcsind(peak_height/sphere_outer_radius)
        else:
            peak_angle = 90.0

        outer_radius = sphere_outer_radius * cosd(base_angle) + allowance
        inner_radius = sphere_inner_radius * cosd(peak_angle) - allowance
        inner_radius = max(inner_radius, 0)

        ring_list.append(
            RingRadii(
                inner=inner_radius,
                outer=outer_radius,
                base=base_height,
                height=material_height
            )
        )

    # duplicate for lower half
    temp_list = []
    for r in reversed(ring_list):
        temp_list.append(
            RingRadii(
                inner=r.inner, 
                outer=r.outer, 
                base=-r.base - material_height,
                height=material_height
            )
        )
    ring_list = temp_list + ring_list

    return ring_list


def draw_rings(ring_list):
    ax = plt.figure().add_subplot(projection='3d')

    for i, ring in enumerate(ring_list, start=1):
        print(f'{i:2d} {ring.base*2.54:6.2f} {ring.outer*2.54:6.2f}, {ring.inner*2.54:6.2f}')
        x = ring.inner * sind(THETA)
        y = ring.inner * cosd(THETA)
        z = ring.base
        ax.plot(x, y, z)
        x = ring.outer * sind(THETA)
        y = ring.outer * cosd(THETA)
        z = ring.base
        ax.plot(x, y, z)
        x = ring.inner * sind(THETA)
        y = ring.inner * cosd(THETA)
        z = ring.base + ring.height
        ax.plot(x, y, z)
        x = ring.outer * sind(THETA)
        y = ring.outer * cosd(THETA)
        z = ring.base + ring.height
        ax.plot(x, y, z)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.view_init(elev=20.0, azim=-35.0)

    plt.show()


if __name__ == '__main__':
    ring_list = get_even_rings()
    draw_rings(ring_list)
    print('Done.')
