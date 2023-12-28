apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-management-service
  labels:
    app: api-management-service
    part-of: new-icons
    tier: backend
spec:
  selector:
    matchLabels:
      app: api-management-service
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
        app: api-management-service
        part-of: new-icons
        tier: backend
    spec:
      containers:
      - name: api-management-service
        image: "gcr.io/new-icons-jtb-dev/api-management-service:BUILD_ID"
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
            name: api-management-service-config