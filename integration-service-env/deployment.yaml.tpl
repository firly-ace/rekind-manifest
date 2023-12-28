apiVersion: apps/v1
kind: Deployment
metadata:
  name: integration-service
  labels:
    app: integration-service
    part-of: new-icons
    tier: backend
spec:
  selector:
    matchLabels:
      app: integration-service
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
        app: integration-service
        part-of: new-icons
        tier: backend
    spec:
      volumes:
        - name: config
          secret:
            secretName: pubsub-sa
      containers:
      - name: integration-service
        image: "gcr.io/new-icons-jtb-dev/integration-service:BUILD_ID"
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
            name: integration-service-config
        - secretRef:
            name: integration-service-secret
        volumeMounts:
          - name: config
            mountPath: '/src/src/config/pubsub-sa.json'
            subPath: 'pubsub-sa.json'
        securityContext:
          privileged: true
          capabilities:
            add:
              - SYS_ADMIN
