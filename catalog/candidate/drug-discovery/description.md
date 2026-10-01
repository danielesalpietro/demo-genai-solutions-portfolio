# drug-discovery — AI for Drug Discovery

## Description

An interactive notebook and Docker-based workflow for molecular property prediction, virtual screening, and QSAR modelling. The demo takes a set of SMILES-encoded molecules and predicts ADMET properties (absorption, distribution, metabolism, excretion, toxicity), classifies activity, and visualises structure-activity relationships.

## Use case / Scenario

A medicinal chemist inputs a list of 100 candidate molecules in SMILES format. The demo predicts solubility, toxicity, and bioavailability for each, ranks candidates by composite score, highlights the top-10 for further experimental validation, and generates a summary report. All computation runs locally with pre-trained models.

## Provenance

| Field | Value |
|---|---|
| Category | generative-ai / life-sciences |
| Primary repository | [mayk-it/AI-drug-discovery](https://github.com/mayk-it/AI-drug-discovery) |
| Deep learning framework | [deepchem/deepchem](https://github.com/deepchem/deepchem) |
| Molecular representation | RDKit (BSD-3-Clause) |
| License (DeepChem) | MIT |
| Last verified | 2026-10-01 |

## Key capabilities

- SMILES parsing and 2D structure rendering (RDKit)
- QSAR modelling: molecular fingerprints + graph neural networks (GNN)
- ADMET property prediction with pre-trained DeepChem models
- Virtual screening over a compound library
- Interactive Jupyter notebook UI or Gradio interface
- LLM-assisted literature search integration (optional; local Ollama)

## Related demos

- `talk-to-data` — same structured output + visualisation pattern
- `private-rag` — LLM-assisted search over scientific literature corpus
