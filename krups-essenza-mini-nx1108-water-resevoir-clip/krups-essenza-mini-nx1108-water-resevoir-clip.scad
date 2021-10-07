/**
 * Nespresso Krups Essenza Mini NX1108 water resevoir clip
 *
 * @copyright 2022, Joffrey van Wageningen <joffrey@ne2000.nl>
 * @license Creative Commons 4.0 BY-SA (https://creativecommons.org/licenses/by/4.0/)
 * 
 * Modules sector and arc
 * @copyright Justin Lin
 * @link https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
 */

module sector(radius, angles, fn = 32) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 32) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}

object_height = 300;
object_length = 146;
object_width = 60;

wall_thickness = 15;
wall_height = object_length - (object_width / 2);

window_width = 66;
window_height = 40;
window_offset = 27;
window_spacing = 24;

clip_offset = 25;

// arc
translate([object_width / 2, object_width / 2, 0]) { 
    linear_extrude(object_height) arc((object_width / 2) - wall_thickness, [90, 270], wall_thickness, 128); 
}; 
    
// wall 1
translate([object_width / 2, (object_width / 2) + wall_thickness, 0]) {
  difference() {
    // a box
    cube([object_length - (object_width / 2), wall_thickness, object_height]);
      
    // with 3 holes
    for(i = [0:1:2]) {
      translate([wall_height - window_width, -1, i * (window_spacing + window_width) + window_offset]) { 
        cube([window_height, wall_thickness + 2, window_width]); 
      };
    };  
  };

  clip_length = object_height - (2 * window_offset) - (2 * clip_offset);

  // clip in 15 degree angle
  translate([35, 0, window_offset + clip_offset]) { 
    rotate([0, 0, 15]) {
      cube([15, wall_thickness + 30, clip_length]);
    };
  };

  // exact positioning of clip ridge
  translate([21, 37.4, window_offset + clip_offset]) { 
    cube([17, 10, clip_length]);
  };
};    

// wall 2
translate([object_width / 2, 0, 0]) { 
    cube([wall_height, wall_thickness, object_height]);
};