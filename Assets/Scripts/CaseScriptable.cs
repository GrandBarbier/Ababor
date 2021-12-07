using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/Case", order = 1)]
public class CaseScriptable : ScriptableObject
{
  public GameObject player;

  public virtual void CaseEffect()
  {
    //eff
  }
}
