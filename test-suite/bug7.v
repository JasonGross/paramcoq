(* Test that translate_constructor looks up constructors in the database
   when they have been registered via Parametricity Register / Realizer Register,
   rather than requiring them to have been translated inline. *)

From Param Require Import Param.
Axiom bool' : Type.
Axiom bool_R : bool -> bool' -> Set.
Parametricity Register bool := bool bool'.
Realizer Register bool_R for bool.
Axiom true' : bool'.
Axiom true_R : bool_R true true'.
Parametricity Register true := true true'.
Realizer Register true_R for true.
Axiom false' : bool'.
Axiom false_R : bool_R false false'.
Parametricity Register false := false false'.
Realizer Register false_R for false.
Axiom bool_rect' : forall P : bool' -> Type, P true' -> P false' -> forall b : bool', P b.
Parametricity Register bool_rect := bool_rect bool_rect'.
Realizer Type bool_rect.
