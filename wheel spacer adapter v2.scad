// Parameters
facet_quality = 100;          // Global facet quality (can be adjusted)

hub_diameter = 60;           // Diameter of the vehicle hub
hub_depth = 15;              // Depth of the hub engagement
wheel_diameter = 70;         // Diameter of the wheel bore
adapter_thickness = 50;      // Thickness of the adapter
bolt_circle_diameter = 110;  // Bolt circle diameter (PCD)
bolt_count = 5;              // Number of bolt holes
bolt_diameter = 12;          // Diameter of the bolt holes
bolt_head_diameter = 18;     // Diameter for countersink/counterbore
bolt_head_depth = 5;         // Depth of the countersink/counterbore
nut_bore_diameter = 20;      // Diameter for nut counterbore
nut_bore_depth = 5;          // Depth of the nut counterbore
outer_diameter = 150;        // Outer diameter of the adapter
hubcentric_ring_height = 5;  // Height of the hubcentric ring

// Main module
module hub_adapter() {
    difference() {
        // Main adapter body
        cylinder(h = adapter_thickness, d = outer_diameter, $fn = facet_quality);

        // Inner hub bore
        translate([0, 0, -1]) {
            cylinder(h = adapter_thickness + 2, d = hub_diameter, $fn = facet_quality);
        }

        // Outer wheel bore
        translate([0, 0, -1]) {
            cylinder(h = hub_depth + 1, d = wheel_diameter, $fn = facet_quality);
        }

        // Original bolt holes
        for (i = [0 : 360 / bolt_count : 360 - (360 / bolt_count)]) {
            rotate([0, 0, i]) {
                translate([bolt_circle_diameter / 2, 0, -1]) {
                    cylinder(h = adapter_thickness + 2, d = bolt_diameter, $fn = facet_quality);
                }
            }
        }

        // Countersinks/counterbores for original bolt holes
        for (i = [0 : 360 / bolt_count : 360 - (360 / bolt_count)]) {
            rotate([0, 0, i]) {
                translate([bolt_circle_diameter / 2, 0, adapter_thickness - bolt_head_depth]) {
                    cylinder(h = bolt_head_depth, d = bolt_head_diameter, $fn = facet_quality);
                }
            }
        }

        // Intermediate bolt holes
        for (i = [360 / (2 * bolt_count) : 360 / bolt_count : 360 - (360 / bolt_count) + 360 / (2 * bolt_count)]) {
            rotate([0, 0, i]) {
                translate([bolt_circle_diameter / 2, 0, -1]) {
                    cylinder(h = adapter_thickness + 2, d = bolt_diameter, $fn = facet_quality);
                }
            }
        }

        // Countersinks/counterbores for intermediate bolt holes
        for (i = [360 / (2 * bolt_count) : 360 / bolt_count : 360 - (360 / bolt_count) + 360 / (2 * bolt_count)]) {
            rotate([0, 0, i]) {
                translate([bolt_circle_diameter / 2, 0, adapter_thickness - bolt_head_depth]) {
                    cylinder(h = bolt_head_depth, d = bolt_head_diameter, $fn = facet_quality);
                }
            }
        }

        // Nut counterbores for intermediate bolt holes (opposite side)
        for (i = [360 / (2 * bolt_count) : 360 / bolt_count : 360 - (360 / bolt_count) + 360 / (2 * bolt_count)]) {
            rotate([0, 0, i]) {
                translate([bolt_circle_diameter / 2, 0, -1]) {
                    cylinder(h = nut_bore_depth, d = nut_bore_diameter, $fn = facet_quality);
                }
            }
        }
    }

    // Add hubcentric ring separately (after the adapter is created)
    translate([0, 0, adapter_thickness]) {
        difference() {
            // Outer ring (matches wheel diameter)
            cylinder(h = hubcentric_ring_height, d = wheel_diameter, $fn = facet_quality);
            // Inner ring (matches hub diameter)
            translate([0, 0, -1]) {
                cylinder(h = hubcentric_ring_height + 2, d = hub_diameter, $fn = facet_quality);
            }
        }
    }
}

// Render the hub adapter with the hubcentric ring
hub_adapter();
