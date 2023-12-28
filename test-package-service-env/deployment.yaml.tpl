apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-package-service
  labels:
    app: test-package-service
    part-of: new-icons
    tier: backend
spec:
  selector:
    matchLabels:
      app: test-package-service
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
        app: test-package-service
        part-of: new-icons
        tier: backend
    spec:
      containers:
      - name: test-package-service
        image: "gcr.io/new-icons-jtb-dev/test-package-service:BUILD_ID"
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
            name: test-package-service-config
        - secretRef:
            name: test-package-service-secret
        securityContext:
          privileged: true
          capabilities:
            add:
              - SYS_ADMIN
        lifecycle:
          postStart:
            exec:
              command: ["sh", "-c", "gcsfuse -o allow_other $MOUNT_BUCKET /src/uploads"]
          preStop:
            exec:
              command: ["sh", "-c", "fusermount -u /src/uploads"]
      - name: cloudsql-proxy
        image: gcr.io/cloudsql-docker/gce-proxy:1.17-alpine
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: 256Mi
            cpu: 500m
        envFrom:
        - configMapRef:
            name: test-package-service-config
        imagePullPolicy: IfNotPresent
        command: ["/cloud_sql_proxy"]
        args: ["-instances=$(DB_INSTANCE)=tcp:5432"]
