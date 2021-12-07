using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Camera cam;

    public float speed = 1;

    public LayerMask plane;
    
    private Ray rayBefore;
    private Ray rayNow;
    
    
    void Start()
    {
        if(cam == null)
            cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 delta1 = Vector3.zero;
        
        if (Input.touchCount >= 1)
        {
            delta1 = positionDelta(Input.GetTouch(0));
            if(Input.GetTouch(0).phase == TouchPhase.Moved)
                cam.transform.Translate(delta1 * speed, Space.World);
        }


        if (Input.touchCount >= 2)
        {
            var pos1  = planePos(Input.GetTouch(0).position);
            var pos2  = planePos(Input.GetTouch(1).position);
            var pos1b = planePos(Input.GetTouch(0).position - Input.GetTouch(0).deltaPosition);
            var pos2b = planePos(Input.GetTouch(1).position - Input.GetTouch(1).deltaPosition);
        
            var zoom = Vector3.Distance(pos1, pos2) /
                       Vector3.Distance(pos1b, pos2b);
            
            if (zoom == 0 || zoom > 10)
                return;
            
            cam.transform.position = Vector3.LerpUnclamped(pos1, cam.transform.position, 1 / zoom);
        }
    }

    public Vector3 positionDelta(Touch touch)
    {
        if(touch.phase != TouchPhase.Moved)
            return Vector3.zero;
        
        Ray rayBefore = cam.ScreenPointToRay(touch.position - touch.deltaPosition);
        Ray rayNow = cam.ScreenPointToRay(touch.position);


        RaycastHit enterBefore, enterNow;
        if (Physics.Raycast(rayBefore, out enterBefore, Mathf.Infinity, plane) &&
            Physics.Raycast(rayNow, out enterNow, Mathf.Infinity, plane))
            return enterBefore.point - enterNow.point; 
        
        return Vector3.zero;
    }

    public Vector3 planePos(Vector2 screenPos)
    {
        RaycastHit enterNow;
        
        Ray rayNow = cam.ScreenPointToRay(screenPos);
        if (Physics.Raycast(rayNow, out enterNow, Mathf.Infinity, plane))
            return enterNow.point;
        
        return Vector3.zero;
    }
}
