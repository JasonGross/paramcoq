(* Test that parametricity_base_type works for induction principles (_ind)
   of registered inductive types (e.g., Result_ind after registering Result).
   Previously, this triggered "Binder has relevance mark set to relevant but
   was expected to be irrelevant" because prime's map_with_binders preserves
   binder relevances, but cast_sort changes Prop to SProp, requiring
   irrelevant relevance on affected binders. *)

From Param Require Import Param.
From Ltac2 Require Import Ltac2.
From Ltac2 Require Import Constr.

Inductive Result := Success | Failure.

(* Register Result and its constructors *)
Axiom Result' : Type.
Parametricity Register Result := Result Result'.
Axiom Success' : Result'.
Parametricity Register Success := Success Success'.
Axiom Failure' : Result'.
Parametricity Register Failure := Failure Failure'.

(* parametricity_base_type on Result_ind should work.
   Result_ind : forall P : Result -> Prop, P Success -> P Failure -> forall r : Result, P r
   After priming, Prop becomes SProp (via cast_sort), requiring binder relevance updates. *)
Parameter imported_Result_ind :
  ltac2:(Control.refine (fun () =>
    parametricity_base_type 'Result_ind)).
