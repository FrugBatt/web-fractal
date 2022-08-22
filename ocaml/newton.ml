(* Génération de la fractale de Newton *)

(* Import static libs *)
open Graphics;;
open Images;;
open Complex;;

(* Getting image meta *)
let z = Sys.argv.(1) and x = Sys.argv.(2) and y = Sys.argv.(3);;

(* Constants *)
let nmax = 50;;

(* Dimensions *)
let size = 2.**(1. -. (float_of_string z));;
let iDim = [|512.; 512.|];;
let gDim = [|(float_of_string x) *. size -. 1.;
            (float_of_string x) *. size -. 1. +. size;
            -1. *. (float_of_string y) *. size +. 1. -. size;
            -1. *. (float_of_string y) *. size +. 1.|];;

(* Polynome definition *)
let p z = sub (pow z {re=4.;im=0.}) {re=1.;im=0.};;
let dp z = 
  if z = zero then zero (* Complex pow error with zero *)
  else mul {re=4.;im=0.} (pow z {re=3.;im=0.});;
let roots = [|
              {re = 1.; im = 0.};
              {re = 0.; im = 1.};
              {re = -1.; im = 0.};
              {re = 0.; im = -1.}
            |];;
let colors =  [|
                (27., 235., 30.);
                (242., 223., 37.);
                (21., 135., 214.);
                (226., 19., 226.)
              |];;

(* Convert position to affix *)
let pos_to_affix x y = {
  re = x *. size /. iDim.(0) +. gDim.(0);
  im = (iDim.(1) -. y) *. size /. iDim.(1) +. gDim.(2)
};;

(* UTIL - Get index of min *)
let min_index arr =
  let n = Array.length arr and id = ref 0 in
    for i = 1 to (n-1) do
      if arr.(i) < arr.(!id) then id := i
    done;
    !id;;

(* Color point *)
let get_color z =
  let eps = 1e-5 and n = ref 0 and z1 = ref z in
    if (dp !z1) = zero then rgb 0 0 0
    else
      let z2 = ref (sub !z1 (div (p !z1) (dp !z1))) in
       while !n < nmax && (norm (sub !z1 !z2)) >= eps do
         z1 := !z2;
         if (dp !z1) = zero then n := nmax
         else z2 := sub !z1 (div (p !z1) (dp !z1));
         n := !n + 1
       done;
       if !n < nmax then
         let ec = [|norm (sub roots.(0) !z1); norm (sub roots.(1) !z1); norm (sub roots.(2) !z1); norm (sub roots.(3) !z1)|] in
           let r, g, b = colors.(min_index ec) and coef = 1. -. (float_of_int !n) /. (float_of_int nmax) in
             rgb (int_of_float (r *. coef)) (int_of_float (g *. coef)) (int_of_float (b *. coef))
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