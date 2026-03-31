(* Test that realizer_base_type works for types with algebraic universe
   expressions (e.g. Type@{max(Set+1,u)}) in their sort.
   Previously, this triggered "Unable to handle arbitrary u+k <= v constraints"
   because algebraic sorts from the constant's type would propagate into
   universe constraints during minimization. *)

From Param Require Import Param.
From Ltac2 Require Import Ltac2.
From Corelib Require Relation_Definitions.

(* Corelib.Relations.Relation_Definitions.relation has type
   Type@{u} -> Type@{max(Set+1,u)} due to the Prop codomain in A -> A -> Prop *)
Parameter imported_Corelib__Relations__RelationD_Definitions__relation :
  ltac2:(Control.refine (fun () =>
    parametricity_base_type 'Corelib.Relations.Relation_Definitions.relation)).
Parameter Corelib__Relations__RelationD_Definitions__relation_iso :
  ltac2:(Control.refine (fun () =>
    realizer_base_type 'Corelib.Relations.Relation_Definitions.relation)).
