// Table Caster
// Developed by: Michael McCool
// Copyright 2018 Michael McCpp;
// License: CC BY 3.0.  See LICENSE.md
include <tols.scad>
//include <smooth_model.scad>
include <smooth_make.scad>
include <bolt_params.scad>
use <bolts.scad>

foot_x = 19;
foot_y = 40;
foot_h = 100;
foot_r = 2;
foot_sm = 4*sm_base;

module foot() {
  hull() {
    translate([ foot_x/2-foot_r, foot_y/2-foot_r,0])
      cylinder(r=foot_r,h=foot_h,$fn=foot_sm);
    translate([-foot_x/2+foot_r, foot_y/2-foot_r,0])
      cylinder(r=foot_r,h=foot_h,$fn=foot_sm);
    translate([ foot_x/2-foot_r,-foot_y/2+foot_r,0])
      cylinder(r=foot_r,h=foot_h,$fn=foot_sm);
    translate([-foot_x/2+foot_r,-foot_y/2+foot_r,0])
      cylinder(r=foot_r,h=foot_h,$fn=foot_sm);
  }
}

hole_r = 1;
hole_tol = 0.2;
hole_sm = 4*sm_base;

module hole() {
  translate([ foot_x/2, foot_y/2,0])
    cylinder(r=hole_r,h=foot_h,$fn=hole_sm);
  translate([-foot_x/2, foot_y/2,0])
    cylinder(r=hole_r,h=foot_h,$fn=hole_sm);
  translate([ foot_x/2,-foot_y/2,0])
    cylinder(r=hole_r,h=foot_h,$fn=hole_sm);
  translate([-foot_x/2,-foot_y/2,0])
    cylinder(r=hole_r,h=foot_h,$fn=hole_sm);
  translate([-foot_x/2-hole_tol,-foot_y/2-hole_tol,0])
    cube([foot_x+2*hole_tol,foot_y+2*hole_tol,foot_h]);
}

washer_r = 16/2;
washer_t = 1;
washer_sm = 8*sm_base;

bolt_r = 6/2;
bolt_sm = 4*sm_base;
nut_r = 12/2;
nut_h = 5;

form_t = 3;
form_wt = 2;
form_taper = 1;
form_b = washer_t + 4;
form_h = 12 + form_b;
form_r = hole_r + form_t;
form_sm = 8*sm_base;

caster_t = 2;
caster_offset_x = foot_x/2+cos(30)*nut_r+caster_t;
caster_offset_y = 0;
caster_r = washer_r + form_wt;

module form_taper(r=form_r) {
  translate([0,0,form_h-form_taper])
    cylinder(r1=r,r2=r-form_taper,h=form_taper,$fn=form_sm);
  translate([0,0,form_taper-eps])
    cylinder(r=r,h=form_h-2*form_taper+2*eps,$fn=form_sm);
  cylinder(r1=r-form_taper,r2=r,h=form_taper,$fn=form_sm);
}
module form() {
  hull() {
    translate([ foot_x/2, foot_y/2,-form_b])
      form_taper();
    translate([-foot_x/2, foot_y/2,-form_b])
      form_taper();
    translate([ foot_x/2,-foot_y/2,-form_b])
      form_taper();
    translate([-foot_x/2,-foot_y/2,-form_b])
      form_taper();
    translate([caster_offset_x,caster_offset_y,-form_b])
      form_taper(caster_r);
  }
}

module base() {
  difference() {
    form();
    hole();
    translate([caster_offset_x,caster_offset_y,-form_b-1])
      cylinder(r=washer_r,h=washer_t+1,$fn=washer_sm);
    translate([caster_offset_x,caster_offset_y,-form_b-1])
      cylinder(r=bolt_r,h=form_h+2,$fn=bolt_sm);
    translate([caster_offset_x,caster_offset_y,form_h-nut_h-form_b])
      rotate(30) cylinder(r=nut_r,h=nut_h+1,$fn=6);
  }
}

//foot();
color([0.9,0.2,0.2]) base();
//form_taper();
