(* Génération de la fractale de Mandelbrot *)

(* Import static libs *)
open Graphics;;
open Images;;
open Complex;;

(* Getting image meta *)
let z = Sys.argv.(1) and x = Sys.argv.(2) and y = Sys.argv.(3);;

(* Constants *)
let nmax = 75;;

(* Dimensions *)
let size = 2.**(2. -. (float_of_string z));;
let iDim = [|512.; 512.|];;
let gDim = [|(float_of_string x) *. size -. 2.;
            (float_of_string x) *. size -. 2. +. size;
            -1. *. (float_of_string y) *. size +. 2. -. size;
            -1. *. (float_of_string y) *. size +. 2.|];;

(* Suite definition *)
let p z c = 
  if z = zero then zero (* Complex pow error with zero *)
  else add (pow z {re=2.;im=0.}) c;;

(* Convert position to affix *)
let pos_to_affix x y = {
  re = x *. size /. iDim.(0) +. gDim.(0);
  im = (iDim.(1) -. y) *. size /. iDim.(1) +. gDim.(2)
};;

(* Color point *)
let get_color z =
  let k = 2. and n = ref 0 and z1 = ref z in
    let z2 = ref (p !z1 z) in
      while !n < nmax && (norm !z1) < k do
        z1 := !z2;
        z2 := (p !z1 z);
        n := !n + 1
      done;
      if !n < nmax then
        let coef = (float_of_int !n) /. (float_of_int nmax) in
          rgb 0 0 (int_of_float (255. *. coef))
      else rgb 0 0 0;;

let im = Array.make_matrix 512 512 (rgb 0 0 0);;

for cx = 0 to 511 do
  for cy = 0 to 511 do
    let color = get_color (pos_to_affix (float_of_int cx) (float_of_int cy)) in
      im.(cy).(cx) <- color
  done;
done;
;;

sauver_image im ("tiles/"^z^"."^x^"."^y^".png");;