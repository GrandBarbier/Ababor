using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamControler : MonoBehaviour
{
    public Camera cam;
    public Transform pivot;

    public float panSpeed, smoothSpeed;
    
    // Start is called before the first frame update
    void Start()
    {
        if (cam == null)
            cam = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.touchCount == 1)
        {
           PanTranslate();
        }
        else if (Input.touchCount >= 2)
        {
            var pos1  = Input.GetTouch(0).position;
            var pos2  = Input.GetTouch(1).position; 
            var pos1b = Input.GetTouch(0).deltaPosition;
            var pos2b = Input.GetTouch(1).deltaPosition;

            var zoom = pos1b / pos2b;
            Debug.Log(zoom);
//            cam.transform.position += cam.transform.rotation * new Vector3(0,0, );
        }
    }

    private void PanTranslate()
    {
        if (Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            Vector3 delta = cam.transform.position + new Vector3(Input.GetTouch(0).deltaPosition.x,0,Input.GetTouch(0).deltaPosition.y) * -panSpeed;
            cam.transform.position = Vector3.LerpUnclamped(cam.transform.position, delta, smoothSpeed);
        }
    }
}
