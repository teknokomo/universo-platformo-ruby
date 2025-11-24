# API Contracts: Clusters Package

**Feature**: Initial Platform Setup for Ruby Implementation  
**Package**: clusters-srv  
**Date**: 2025-11-17  
**API Version**: v1

## Overview

This document defines the REST API contracts for the Clusters package, including Clusters, Domains, and Resources endpoints.

**Base URL**: `/clusters`  
**Authentication**: Required (JWT Bearer token)  
**Content-Type**: `application/json`  
**Versioning**: URL-based (`/api/v1/clusters`)

---

## Authentication

All endpoints require authentication via JWT token in the Authorization header:

```http
Authorization: Bearer <jwt_token>
```

**Unauthenticated Response** (401):
```json
{
  "error": "Unauthorized",
  "message": "Valid authentication token required"
}
```

---

## Clusters Endpoints

### List Clusters

**Endpoint**: `GET /api/v1/clusters`  
**Description**: Retrieve all clusters for the authenticated user  
**Authorization**: Required

**Query Parameters**:
- `page` (integer, optional): Page number for pagination (default: 1)
- `per_page` (integer, optional): Items per page (default: 20, max: 100)
- `sort` (string, optional): Sort field (default: `created_at`)
- `order` (string, optional): Sort order (`asc` or `desc`, default: `desc`)

**Request Example**:
```http
GET /api/v1/clusters?page=1&per_page=20&sort=name&order=asc
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Success Response** (200):
```json
{
  "data": [
    {
      "id": 1,
      "type": "cluster",
      "attributes": {
        "name": "Production Cluster",
        "description": "Main production environment",
        "created_at": "2025-11-17T10:00:00Z",
        "updated_at": "2025-11-17T10:00:00Z"
      },
      "relationships": {
        "domains": {
          "data": [
            { "id": 1, "type": "domain" },
            { "id": 2, "type": "domain" }
          ]
        }
      }
    }
  ],
  "meta": {
    "total": 45,
    "page": 1,
    "per_page": 20,
    "total_pages": 3
  }
}
```

---

### Get Cluster

**Endpoint**: `GET /api/v1/clusters/:id`  
**Description**: Retrieve a specific cluster by ID  
**Authorization**: Required (must own cluster)

**Path Parameters**:
- `id` (integer, required): Cluster ID

**Request Example**:
```http
GET /api/v1/clusters/1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Success Response** (200):
```json
{
  "data": {
    "id": 1,
    "type": "cluster",
    "attributes": {
      "name": "Production Cluster",
      "description": "Main production environment",
      "created_at": "2025-11-17T10:00:00Z",
      "updated_at": "2025-11-17T10:00:00Z"
    },
    "relationships": {
      "domains": {
        "data": [
          { "id": 1, "type": "domain" },
          { "id": 2, "type": "domain" }
        ]
      }
    }
  },
  "included": [
    {
      "id": 1,
      "type": "domain",
      "attributes": {
        "name": "API Domain",
        "description": "API services"
      }
    },
    {
      "id": 2,
      "type": "domain",
      "attributes": {
        "name": "Web Domain",
        "description": "Web applications"
      }
    }
  ]
}
```

**Error Response** (404):
```json
{
  "error": "Not Found",
  "message": "Cluster with id 1 not found"
}
```

---

### Create Cluster

**Endpoint**: `POST /api/v1/clusters`  
**Description**: Create a new cluster  
**Authorization**: Required

**Request Body**:
```json
{
  "cluster": {
    "name": "New Cluster",
    "description": "Description of the cluster"
  }
}
```

**Request Example**:
```http
POST /api/v1/clusters
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "cluster": {
    "name": "New Cluster",
    "description": "Description of the cluster"
  }
}
```

**Success Response** (201):
```json
{
  "data": {
    "id": 2,
    "type": "cluster",
    "attributes": {
      "name": "New Cluster",
      "description": "Description of the cluster",
      "created_at": "2025-11-17T11:00:00Z",
      "updated_at": "2025-11-17T11:00:00Z"
    },
    "relationships": {
      "domains": {
        "data": []
      }
    }
  }
}
```

**Validation Error Response** (422):
```json
{
  "error": "Unprocessable Entity",
  "message": "Validation failed",
  "details": {
    "name": ["can't be blank"],
    "description": []
  }
}
```

---

### Update Cluster

**Endpoint**: `PATCH /api/v1/clusters/:id`  
**Description**: Update an existing cluster  
**Authorization**: Required (must own cluster)

**Path Parameters**:
- `id` (integer, required): Cluster ID

**Request Body**:
```json
{
  "cluster": {
    "name": "Updated Cluster Name",
    "description": "Updated description"
  }
}
```

**Success Response** (200):
```json
{
  "data": {
    "id": 1,
    "type": "cluster",
    "attributes": {
      "name": "Updated Cluster Name",
      "description": "Updated description",
      "created_at": "2025-11-17T10:00:00Z",
      "updated_at": "2025-11-17T11:30:00Z"
    },
    "relationships": {
      "domains": {
        "data": [
          { "id": 1, "type": "domain" }
        ]
      }
    }
  }
}
```

---

### Delete Cluster

**Endpoint**: `DELETE /api/v1/clusters/:id`  
**Description**: Delete a cluster (soft delete)  
**Authorization**: Required (must own cluster)

**Path Parameters**:
- `id` (integer, required): Cluster ID

**Request Example**:
```http
DELETE /api/v1/clusters/1
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Success Response** (204):
```
No Content
```

**Error Response - Has Domains** (422):
```json
{
  "error": "Unprocessable Entity",
  "message": "Cannot delete cluster with associated domains",
  "details": {
    "domains_count": 3
  }
}
```

---

## Domains Endpoints

### List Domains

**Endpoint**: `GET /api/v1/domains`  
**Description**: Retrieve all domains across user's clusters  
**Authorization**: Required

**Query Parameters**: Same pagination as clusters

**Success Response** (200):
```json
{
  "data": [
    {
      "id": 1,
      "type": "domain",
      "attributes": {
        "name": "API Domain",
        "description": "API services",
        "created_at": "2025-11-17T10:00:00Z",
        "updated_at": "2025-11-17T10:00:00Z"
      },
      "relationships": {
        "clusters": {
          "data": [
            { "id": 1, "type": "cluster" }
          ]
        },
        "resources": {
          "data": [
            { "id": 1, "type": "resource" }
          ]
        }
      }
    }
  ],
  "meta": {
    "total": 12,
    "page": 1,
    "per_page": 20,
    "total_pages": 1
  }
}
```

---

### Get Domain

**Endpoint**: `GET /api/v1/domains/:id`  
**Description**: Retrieve a specific domain  
**Authorization**: Required (must have access via cluster ownership)

**Success Response** (200):
```json
{
  "data": {
    "id": 1,
    "type": "domain",
    "attributes": {
      "name": "API Domain",
      "description": "API services",
      "created_at": "2025-11-17T10:00:00Z",
      "updated_at": "2025-11-17T10:00:00Z"
    },
    "relationships": {
      "clusters": {
        "data": [
          { "id": 1, "type": "cluster" }
        ]
      },
      "resources": {
        "data": [
          { "id": 1, "type": "resource" },
          { "id": 2, "type": "resource" }
        ]
      }
    }
  }
}
```

---

### Create Domain

**Endpoint**: `POST /api/v1/domains`  
**Description**: Create a new domain  
**Authorization**: Required

**Request Body**:
```json
{
  "domain": {
    "name": "New Domain",
    "description": "Domain description"
  }
}
```

**Success Response** (201):
```json
{
  "data": {
    "id": 3,
    "type": "domain",
    "attributes": {
      "name": "New Domain",
      "description": "Domain description",
      "created_at": "2025-11-17T12:00:00Z",
      "updated_at": "2025-11-17T12:00:00Z"
    },
    "relationships": {
      "clusters": {
        "data": []
      },
      "resources": {
        "data": []
      }
    }
  }
}
```

---

### Update Domain

**Endpoint**: `PATCH /api/v1/domains/:id`  
**Description**: Update an existing domain  
**Authorization**: Required (must have access via cluster)

**Request Body**: Same as Create Domain

**Success Response** (200): Similar to Get Domain

---

### Delete Domain

**Endpoint**: `DELETE /api/v1/domains/:id`  
**Description**: Delete a domain (soft delete)  
**Authorization**: Required

**Success Response** (204): No Content

**Error Response - Has Resources** (422):
```json
{
  "error": "Unprocessable Entity",
  "message": "Cannot delete domain with associated resources",
  "details": {
    "resources_count": 5
  }
}
```

---

## Resources Endpoints

### List Resources

**Endpoint**: `GET /api/v1/resources`  
**Description**: Retrieve all resources across user's domains  
**Authorization**: Required

**Query Parameters**:
- Standard pagination parameters
- `resource_type` (string, optional): Filter by type

**Success Response** (200):
```json
{
  "data": [
    {
      "id": 1,
      "type": "resource",
      "attributes": {
        "name": "API Endpoint",
        "resource_type": "api",
        "configuration": {
          "endpoint": "https://api.example.com",
          "method": "GET"
        },
        "created_at": "2025-11-17T10:00:00Z",
        "updated_at": "2025-11-17T10:00:00Z"
      },
      "relationships": {
        "domains": {
          "data": [
            { "id": 1, "type": "domain" }
          ]
        }
      }
    }
  ],
  "meta": {
    "total": 30,
    "page": 1,
    "per_page": 20,
    "total_pages": 2
  }
}
```

---

### Create Resource

**Endpoint**: `POST /api/v1/resources`  
**Description**: Create a new resource  
**Authorization**: Required

**Request Body**:
```json
{
  "resource": {
    "name": "New Resource",
    "resource_type": "api",
    "configuration": {
      "endpoint": "https://api.example.com",
      "method": "POST",
      "headers": {
        "Content-Type": "application/json"
      }
    }
  }
}
```

**Success Response** (201): Similar to list format

---

## Relationship Endpoints

### Add Domain to Cluster

**Endpoint**: `POST /api/v1/clusters/:cluster_id/domains`  
**Description**: Associate an existing domain with a cluster  
**Authorization**: Required (must own cluster)

**Request Body**:
```json
{
  "domain_id": 1
}
```

**Success Response** (200):
```json
{
  "message": "Domain added to cluster successfully",
  "data": {
    "cluster_id": 1,
    "domain_id": 1
  }
}
```

**Idempotent**: Adding same domain twice returns 200 (no error)

---

### Remove Domain from Cluster

**Endpoint**: `DELETE /api/v1/clusters/:cluster_id/domains/:domain_id`  
**Description**: Remove domain from cluster  
**Authorization**: Required (must own cluster)

**Success Response** (204): No Content

---

### Add Resource to Domain

**Endpoint**: `POST /api/v1/domains/:domain_id/resources`  
**Description**: Associate an existing resource with a domain  
**Authorization**: Required (must have access to domain)

**Request Body**:
```json
{
  "resource_id": 1
}
```

**Success Response** (200):
```json
{
  "message": "Resource added to domain successfully",
  "data": {
    "domain_id": 1,
    "resource_id": 1
  }
}
```

---

### Remove Resource from Domain

**Endpoint**: `DELETE /api/v1/domains/:domain_id/resources/:resource_id`  
**Description**: Remove resource from domain  
**Authorization**: Required

**Success Response** (204): No Content

---

## Error Responses

### Standard Error Format

All errors follow this structure:

```json
{
  "error": "Error Type",
  "message": "Human-readable message",
  "details": {
    "field_name": ["error message 1", "error message 2"]
  }
}
```

### HTTP Status Codes

- `200 OK`: Successful GET, PATCH, relationship operations
- `201 Created`: Successful POST
- `204 No Content`: Successful DELETE
- `400 Bad Request`: Invalid request format
- `401 Unauthorized`: Authentication required or failed
- `403 Forbidden`: Authenticated but not authorized
- `404 Not Found`: Resource doesn't exist
- `422 Unprocessable Entity`: Validation failed
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server error

---

## Rate Limiting

All endpoints are rate-limited:

- **Authenticated users**: 1000 requests per hour
- **Per endpoint**: 100 requests per minute

**Rate Limit Headers**:
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1700222400
```

**Rate Limit Exceeded Response** (429):
```json
{
  "error": "Too Many Requests",
  "message": "Rate limit exceeded. Try again in 3600 seconds.",
  "details": {
    "retry_after": 3600
  }
}
```

---

## Pagination

All list endpoints support pagination:

**Query Parameters**:
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 20, max: 100)

**Response Meta**:
```json
{
  "meta": {
    "total": 100,
    "page": 2,
    "per_page": 20,
    "total_pages": 5
  }
}
```

**Link Headers** (RFC 5988):
```http
Link: <https://api.example.com/clusters?page=1>; rel="first",
      <https://api.example.com/clusters?page=3>; rel="next",
      <https://api.example.com/clusters?page=5>; rel="last"
```

---

## Versioning Strategy

API versioning uses URL-based versioning:

- **Current version**: v1 (`/api/v1/`)
- **Future versions**: v2, v3, etc.
- **Deprecation**: 6-month notice before version retirement
- **Version Header**: `Accept: application/vnd.universo.v1+json` (alternative)

---

**Contract Status**: ✅ COMPLETE  
**Ready for Implementation**: YES  
**Blockers**: NONE
