import { z } from "zod";
const VALID_ROLES = ["admin", "kasir", "staff_gudang"];

const registerSchema = z.object({
  // Email Validation
  email: z
    .string({
      required_error: "Format email tidak valid.",
      invalid_type_error: "Format email tidak valid.",
    })
    .regex(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, "Format email tidak valid.")
    .endsWith("@gmail.com", "Email harus beralamat di @gmail.com"),

  // Password Validation
  password: z
    .string({
      required_error: "Password minimal 8 karakter.",
      invalid_type_error: "Password minimal 8 karakter.",
    })
    .superRefine((val, ctx) => {
      if (val.length < 8) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "Password minimal 8 karakter.",
        });
      } else if (!/[A-Z]/.test(val) || !/[0-9]/.test(val)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          message: "Password harus mengandung huruf kapital dan angka.",
        });
      }
    }),

  // Id Cabang Validation
  id_cabang: z.string().min(1, "Id Cabang wajib diisi."),

  // Id Role Validation
  id_role: z
    .string()
    .refine((val) => VALID_ROLES.includes(val), {
      message: "Role tidak valid.",
    })
    .optional(),
});

function validateRegisterInput(data) {
  const result = registerSchema.safeParse(data);
  if (!result.success) {
    return result.error.issues.map((err) => err.message);
  }
  return [];
}

const loginSchema = z.object({
  // Email Validation
  email: z
    .string({
      required_error: "Email wajib diisi.",
      invalid_type_error: "Email wajib diisi.",
    })
    .min(1, "Email wajib diisi."),

  // Password Validation
  password: z
    .string({
      required_error: "Password wajib diisi.",
      invalid_type_error: "Password wajib diisi.",
    })
    .min(1, "Password wajib diisi."),
});

function validateLoginInput(data) {
  const result = loginSchema.safeParse(data);
  if (!result.success) {
    return result.error.issues.map((err) => err.message);
  }
  return [];
}

export { validateRegisterInput, validateLoginInput, VALID_ROLES };
