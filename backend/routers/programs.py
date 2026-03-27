from fastapi import APIRouter, HTTPException
from services.supabase_client import supabase_admin

router = APIRouter(prefix="/api/programs", tags=["Programs"])


# ── 1. GET /api/programs ──────────────────────────────────────────────────────
# Returns all 4 programs (one per archetype path)

@router.get("/")
def list_programs():
    try:
        response = supabase_admin.table("programs") \
            .select("id, title, description, archetype_name, total_phases, created_at") \
            .order("created_at", desc=False) \
            .execute()
        return response.data
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch programs: {str(e)}")


# ── 2. GET /api/programs/{program_id}/modules ─────────────────────────────────
# Returns all modules + their lessons for a specific program

@router.get("/{program_id}/modules")
def get_program_modules(program_id: str):
    try:
        modules_res = supabase_admin.table("modules") \
            .select("id, title, description, learning_objective, phase_number, order_index") \
            .eq("program_id", program_id) \
            .order("order_index", desc=False) \
            .execute()

        if not modules_res.data:
            raise HTTPException(status_code=404, detail="Program not found or has no modules")

        module_ids = [m["id"] for m in modules_res.data]

        lessons_res = supabase_admin.table("lessons") \
            .select("id, module_id, title, content, description, lesson_type, source, author, order_index, video_url") \
            .in_("module_id", module_ids) \
            .order("order_index", desc=False) \
            .execute()

        # Group lessons under their module
        lessons_by_module = {}
        for lesson in lessons_res.data:
            mid = lesson["module_id"]
            lessons_by_module.setdefault(mid, []).append(lesson)

        for module in modules_res.data:
            module["lessons"] = lessons_by_module.get(module["id"], [])

        return modules_res.data

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch modules: {str(e)}")


# ── 3. GET /api/programs/archetype/{archetype_name} ───────────────────────────
# Shortcut: get a program by archetype name (e.g. "Growth PM")

@router.get("/archetype/{archetype_name}")
def get_program_by_archetype(archetype_name: str):
    try:
        response = supabase_admin.table("programs") \
            .select("id, title, description, archetype_name, total_phases") \
            .eq("archetype_name", archetype_name) \
            .single() \
            .execute()

        if not response.data:
            raise HTTPException(status_code=404, detail=f"No program found for archetype: {archetype_name}")

        return response.data
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch program: {str(e)}")
