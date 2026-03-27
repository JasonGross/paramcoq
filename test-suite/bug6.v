(* Test that Ltac2 parametricity externals work when called from inside
   a match expression (which introduces local binders in the proof env).
   Previously, this triggered an assertion failure because the Ltac2
   externals used Proofview.tclENV (which includes local binders) instead
   of Global.env() (which has an empty rel_context as required by
   translate_type/translate_term). *)

Require Import Ltac2.Ltac2.
From Ltac2 Require Import Constr.

Declare ML Module "coq-paramcoq.plugin".

Ltac2 @ external parametricity_base_type : constr -> constr
  := "coq-paramcoq.plugin" "parametricity_base_type".
Ltac2 @ external realizer_base_type : constr -> constr
  := "coq-paramcoq.plugin" "realizer_base_type".

(* Notation that calls the Ltac2 external inside a match, creating a
   non-empty rel_context at the tactic call site. *)
Ltac2 open_pretype (c : preterm) :=
  Constr.Pretype.pretype Constr.Pretype.Flags.open_constr_flags_with_tc
    Constr.Pretype.expected_without_type_constraint c.

Abbreviation base_type_of f :=
  (match f return _ with _ =>
    ltac2:(Control.refine (fun () => parametricity_base_type (open_pretype f)))
  end) (only parsing).

Abbreviation realizer_type_of f :=
  (match f return _ with _ =>
    ltac2:(Control.refine (fun () => realizer_base_type (open_pretype f)))
  end) (only parsing).

(* Simple test with nat *)
Parameter nat_base : base_type_of nat.
Parameter nat_realizer : realizer_type_of nat.

(* Test with a class involving Prop (exercises the Prop sort translation) *)
Axiom RandomSeed : Type.
Inductive GenType (A:Type) : Type := MkGen : (nat -> RandomSeed -> A) -> GenType A.
Definition G := GenType.

Class GenSuchThat (A : Type) (P : A -> Prop) :=
  { arbitraryST : G (option A) }.

Parameter GenSuchThat_base : base_type_of GenSuchThat.
Parameter GenSuchThat_realizer : realizer_type_of GenSuchThat.
