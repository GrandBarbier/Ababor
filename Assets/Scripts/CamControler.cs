using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamControler : MonoBehaviour
{
    public GameplayManager gameplayManager;
    public Camera cam;

    [SerializeField]
    private float panSpeed, smoothSpeed, zoomSpeed, minLimit, maxLimit, targetOffset, bounceSpeed, transSpeed;

    [SerializeField]
    private bool posSaved, moving, bouncing;

    [SerializeField]
    private Vector3 savedPos, minPos, maxPos;

    private Vector3 panPos0, panPos1, panPos2, panPos3;

    public LayerMask mask, panMask;

    [SerializeField]
    private GameObject playerTarget;
    
    public List<GameObject> playersTargets = new List<GameObject>();
    
    // Start is called before the first frame update
    void Start()
    {
        if (cam == null)
            cam = Camera.main;
        
        for (int i = 0; i < gameplayManager.allPlayer.Count; i++)
        {
            playersTargets.Add(gameplayManager.allPlayer[i].transform.GetChild(0).gameObject);
        }
        
        GoToPlayer();
    }

    // Update is called once per frame
    void Update()
    {
        SetZoomLimits();
        SetPanLimits();

        if (!moving)
        {
            if (Input.touchCount == 1)
            {
                PanTranslate();
            }
            else if (Input.touchCount >= 2 && !bouncing)
            {
                ZoomTranslate();
            }
            
            if (Input.touchCount < 2)
            {
                if (posSaved)
                {
                    GoToSavedPos();
                }
                if (Vector3.Distance(cam.transform.position, savedPos) < targetOffset)
                {
                    posSaved = false;
                    bouncing = false;
                }
            }
        }
        else
        {
            cam.transform.position = Vector3.LerpUnclamped(cam.transform.position, playerTarget.transform.position, Time.deltaTime * transSpeed);
            float dist = Vector3.Distance(cam.transform.position, playerTarget.transform.position);
            if (dist <= targetOffset)
            {
                moving = false;
            }
        }
    }

    private void PanTranslate()
    {
        if (Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            Vector3 delta = cam.transform.position + new Vector3(- Input.GetTouch(0).deltaPosition.x,0,- Input.GetTouch(0).deltaPosition.y) * panSpeed;
            cam.transform.position = Vector3.LerpUnclamped(cam.transform.position, delta, smoothSpeed);
        }
    }

    private void ZoomTranslate()
    {
        Touch touch1 = Input.GetTouch(0);
        Touch touch2 = Input.GetTouch(1);

        Vector2 pos1  = touch1.position - touch1.deltaPosition;
        Vector2 pos2  = touch2.position - touch2.deltaPosition;

        float prevM = (pos1 - pos2).magnitude;
        float currentM = (touch1.position - touch2.position).magnitude;

        float diff = currentM - prevM;

        Vector3 delta = cam.transform.position + cam.transform.rotation * new Vector3(0, 0, diff * zoomSpeed);

        if (Physics.Raycast(cam.transform.position, cam.transform.rotation * Vector3.forward, out RaycastHit hit, Mathf.Infinity, mask))
        {
            Debug.DrawLine(cam.transform.position, hit.point, Color.red);
            cam.transform.position = Vector3.LerpUnclamped(cam.transform.position,hit.point , (diff * zoomSpeed / 100) * smoothSpeed * 0.1f);
        }
        else
        {
            cam.transform.position = Vector3.LerpUnclamped(cam.transform.position, delta, smoothSpeed * 0.1f);
        }
    }

    private void SetZoomLimits()
    {
        if (Physics.Raycast(cam.transform.position, cam.transform.rotation * Vector3.forward, out RaycastHit hit, Mathf.Infinity, mask))
        {
            Vector3 dir = (cam.transform.position - hit.point).normalized;

            minPos = hit.point + dir * minLimit;
            maxPos = hit.point + dir * maxLimit;
            
            Debug.DrawLine(hit.point,  minPos, Color.red);
            Debug.DrawLine(minPos, maxPos, Color.green);

            if (Vector3.Distance(minPos, maxPos) < Vector3.Distance(minPos, cam.transform.position))
            {
                Debug.DrawLine(maxPos, cam.transform.position, Color.red);
                SavePos(maxPos);
            }
            else if (Vector3.Distance(hit.point, minPos) > Vector3.Distance(hit.point, cam.transform.position))
            {
                SavePos(minPos);
            }
            else
            {
                posSaved = false;
                bouncing = false;
            }
        }
    }

    private void SetPanLimits()
    {
        if (Physics.Raycast(cam.transform.position, Vector3.right, out RaycastHit hit0, Mathf.Infinity, panMask))
        {
            panPos0 = hit0.point;
        }
        else
        {
            Debug.DrawLine(cam.transform.position, panPos0, Color.red);
            SavePos(panPos0);
        }
        
        if (Physics.Raycast(cam.transform.position, Vector3.left, out RaycastHit hit1, Mathf.Infinity, panMask))
        {
            panPos1 = hit1.point;
        }
        else
        {
            Debug.DrawLine(cam.transform.position, panPos1, Color.red);
            SavePos(panPos1);
        }
        
        if (Physics.Raycast(cam.transform.position, Vector3.forward, out RaycastHit hit2, Mathf.Infinity, panMask))
        {
            panPos2 = hit2.point;
        }
        else
        {
            Debug.DrawLine(cam.transform.position, panPos2, Color.red);
            SavePos(panPos2);
        }
        
        if (Physics.Raycast(cam.transform.position, Vector3.back, out RaycastHit hit3, Mathf.Infinity, panMask))
        {
            panPos3 = hit3.point;
        }
        else
        {
            Debug.DrawLine(cam.transform.position, panPos3, Color.red);
            SavePos(panPos3);
        }
    }
    
    private void SavePos(Vector3 pos)
    {
        savedPos = pos;
        posSaved = true;
    }
    
    private void GoToSavedPos()
    {
        bouncing = true;
        cam.transform.position = Vector3.LerpUnclamped(cam.transform.position, savedPos, bounceSpeed);
    }
    
    public void GoToPlayer()
    {
        playerTarget = playersTargets[gameplayManager.playerIndex];
        moving = true;
    }
}
