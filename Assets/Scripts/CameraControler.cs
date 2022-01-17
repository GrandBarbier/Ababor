using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControler : MonoBehaviour
{
    public Camera cam;
    protected Plane Plane;
    
    [SerializeField] 
    private float targetOffset, minLimit, maxLimit, bounceSpeed, zoomBreak, transSpeed;

    [SerializeField] 
    private Vector3 planeTarget, target, maxLimitPos, minLimitPos, savedPos;
    private Vector3 velocity = Vector3.zero;

    [SerializeField] 
    private GameObject playerTarget;

    [SerializeField] 
    private bool bouncing, canBounce,isMoving;
    
    public GameplayManager gameplayManager;
    
    public List<GameObject> playersTargets = new List<GameObject>();


    private void Start()
    {
        if (cam == null)
            cam = Camera.main;
        
        minLimitPos = new Vector3(cam.transform.position.x, cam.transform.position.y - 10, cam.transform.position.z);
        maxLimitPos = new Vector3(cam.transform.position.x, cam.transform.position.y + 10, cam.transform.position.z);

        for (int i = 0; i < gameplayManager.allPlayer.Count; i++)
        {
            playersTargets.Add(gameplayManager.allPlayer[i].transform.GetChild(0).gameObject);
        }
       
        GoToPlayer();
    }

    private void Update()
    {
        if (!isMoving)
        {
            //Update Plane
            if (Input.touchCount >= 1)
                Plane.SetNormalAndPosition(transform.up, transform.position);
            
            var Delta1 = Vector3.zero;
        
            //Scroll
            if (Input.touchCount >= 1 && !bouncing)
            {
                Delta1 = PlanePositionDelta(Input.GetTouch(0));
                if (Input.GetTouch(0).phase == TouchPhase.Moved)
                    cam.transform.Translate(Delta1, Space.World);
            }

            //Pinch
            if (Input.touchCount >= 2 && !bouncing)
            {
                var pos1  = PlanePosition(Input.GetTouch(0).position);
                var pos2  = PlanePosition(Input.GetTouch(1).position); 
                var pos1b = PlanePosition(Input.GetTouch(0).position - Input.GetTouch(0).deltaPosition);
                var pos2b = PlanePosition(Input.GetTouch(1).position - Input.GetTouch(1).deltaPosition);

                //calc zoom
                var zoom = Vector3.Distance(pos1, pos2) /
                       Vector3.Distance(pos1b, pos2b);

            //edge case
                if (zoom == 0 || zoom > 10)
                    return;

                planeTarget = (pos1 + pos2) / 2;
                target = Vector3.MoveTowards(planeTarget, cam.transform.position, targetOffset);
            
                Vector3 dir = (cam.transform.position - target).normalized;
            
                minLimitPos = target + dir * minLimit;
                maxLimitPos = target + dir * maxLimit;
            
                if (Vector3.Distance(cam.transform.position, target) > Vector3.Distance(minLimitPos, maxLimitPos))
                {
                    zoom = (Vector3.Distance(pos1, pos2) + zoomBreak * Vector3.Distance(cam.transform.position, maxLimitPos)) / 
                           (Vector3.Distance(pos1b, pos2b) + zoomBreak * Vector3.Distance(cam.transform.position, maxLimitPos));
                    savedPos = maxLimitPos;
                    canBounce = true;
                }
                else if (Vector3.Distance(cam.transform.position, target) < Vector3.Distance(target, minLimitPos))
                {
                    savedPos = minLimitPos;
                    canBounce = true;
                }
                else
                {
                    canBounce = false;
                }
            
                //Move cam amount the mid ray
                cam.transform.position = Vector3.LerpUnclamped(target, cam.transform.position, 1 / zoom);
                        
                //Debug
                Debug.DrawLine(planeTarget, minLimitPos, Color.red);
                Debug.DrawLine(minLimitPos, maxLimitPos, Color.green);
                if (Vector3.Distance(minLimitPos, cam.transform.position) > Vector3.Distance(minLimitPos, maxLimitPos))
                {
                    Debug.DrawLine(maxLimitPos, cam.transform.position, Color.red);
                }
            }
        
            if (Input.touchCount < 2)
            {
                if (canBounce)
                {
                    bouncing = true;
                    cam.transform.position = Vector3.SmoothDamp(cam.transform.position, savedPos, ref velocity, Time.deltaTime * bounceSpeed);
                }

                if (cam.transform.position == savedPos)
                {
                    bouncing = false;
                    canBounce = false;
                }
            }
        }
        else
        {
            cam.transform.position = Vector3.SmoothDamp(cam.transform.position, playerTarget.transform.position, ref velocity, Time.deltaTime * transSpeed);
            float dist = Vector3.Distance(cam.transform.position, playerTarget.transform.position);
            if (dist <= 0.1f)
            {
                isMoving = false;
            }
        }
    }

    protected Vector3 PlanePositionDelta(Touch touch)
    {
        //not moved
        if (touch.phase != TouchPhase.Moved)
            return Vector3.zero;

        //delta
        var rayBefore = cam.ScreenPointToRay(touch.position - touch.deltaPosition);
        var rayNow = cam.ScreenPointToRay(touch.position);
        if (Plane.Raycast(rayBefore, out var enterBefore) && Plane.Raycast(rayNow, out var enterNow))
            return rayBefore.GetPoint(enterBefore) - rayNow.GetPoint(enterNow);

        //not on plane
        return Vector3.zero;
    }

    protected Vector3 PlanePosition(Vector2 screenPos)
    {
        //position
        var rayNow = cam.ScreenPointToRay(screenPos);
        if (Plane.Raycast(rayNow, out var enterNow))
            return rayNow.GetPoint(enterNow);

        return Vector3.zero;
    }
    
    public void GoToPlayer()
    {
        playerTarget = playersTargets[gameplayManager.playerIndex];
        isMoving = true;
    }
}