using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = new Vector3(math.sin(Time.realtimeSinceStartup) * 10, 0, 8.74f);
    }
}
