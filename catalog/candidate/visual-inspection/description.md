# visual-inspection — Computer Vision Quality Audit

## Description

A webcam or sample images of industrial components are fed to an anomaly detection model. The demo detects surface defects, classifies the finding (scratch, dent, contamination, etc.), scores confidence, and generates a structured quality event with image, label, bounding box, and metadata. An optional dashboard aggregates findings across a batch.

## Use case / Scenario

An operator points a webcam at a set of sample parts (included as fixtures). The demo processes each frame, highlights detected anomalies, classifies them, and generates a JSON quality event that could feed a MES or quality management system. The demo illustrates edge AI inference with no cloud dependency.

## Provenance

| Field | Value |
|---|---|
| Category | enterprise-ai / computer-vision |
| Primary stack (enterprise) | [octo-technology/VIO](https://github.com/octo-technology/VIO) |
| Anomaly detection | [openvinotoolkit/anomalib](https://github.com/openvinotoolkit/anomalib) |
| Primary stack (rapid demo) | [karakurai/visual_inspection](https://github.com/karakurai/visual_inspection) |
| Alternative | [awslabs/sagemaker-defect-detection](https://github.com/awslabs/sagemaker-defect-detection) |
| License (Anomalib) | Apache-2.0 |
| License (VIO) | To be verified on current repo state |
| Last verified | 2026-10-01 |

## Key capabilities

**Option A — VIO (modular edge-to-hub):**
- Edge component, model serving, orchestration, and monitoring hub in separate services
- Pluggable model backend (Anomalib / OpenVINO / custom)
- Centralised dashboard for multi-camera deployments

**Option B — visual_inspection (rapid demo):**
- Single Python service, webcam-ready, CPU-only, no dedicated GPU required
- Gradio live UI; demo-ready in under 5 minutes from `docker compose up`
- Uses pre-trained PaDiM or EfficientAD from Anomalib

## Related demos

- `context-fabric` — quality events produced here can feed an operational context fabric
- `embodied-ai` — visual perception component for robot manipulation
