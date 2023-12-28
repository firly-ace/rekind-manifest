apiVersion: apps/v1
kind: Deployment
metadata:
  name: activity-service
  labels:
    app: activity-service
    part-of: new-icons
    tier: backend
spec:
  selector:
    matchLabels:
      app: activity-service
      part-of: new-icons
      tier: backend
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: activity-service
        part-of: new-icons
        tier: backend
    spec:
      volumes:
        - name: config
          secret:
            secretName: pubsub-sa
      containers:
      - name: activity-service
        image: "gcr.io/new-icons-jtb-dev/icons-api-activity-service:BUILD_ID"
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: 256Mi
            cpu: 500m
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 8080
        envFrom:
        - configMapRef:
            name: activity-service-config
        volumeMounts:
          - name: config
            mountPath: '/src/src/config/pubsub-sa.json'
            subPath: 'pubsub-sa.json'
        securityContext:
          privileged: true
          capabilities:
            add:
              - SYS_ADMIN
        lifecycle:
          postStart:
            exec:
              command: ["sh", "-c", "gcsfuse -o allow_other --only-dir activity-service/ $MOUNT_BUCKET /src/uploads"]
          preStop:
            exec:
              command: ["sh", "-c", "fusermount -u /src/uploads"]