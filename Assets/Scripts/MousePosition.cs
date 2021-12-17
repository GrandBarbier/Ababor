using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePosition : MonoBehaviour
{
    public Camera mainCamera;
    public LayerMask mask;
    public GameObject caseTouch;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
      //  Ray ray = ;
        if (Physics.Raycast(mainCamera.ScreenPointToRay(Input.mousePosition), out RaycastHit raycastHit, 100,mask))
        {
            caseTouch = raycastHit.collider.gameObject;
           
        }
    }
}
