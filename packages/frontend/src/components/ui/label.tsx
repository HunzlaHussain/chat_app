import * as React from "react"
import * as LabelPrimitive from "@radix-ui/react-label"

export interface LabelProps
  extends React.LabelHTMLAttributes<HTMLLabelElement> {
  asChild?: boolean
}

const Label = React.forwardRef<HTMLLabelElement, LabelProps>(
  ({ asChild = false, ...props }, ref) => {
    const Comp: any = asChild ? LabelPrimitive.Root : "label"; 

    return <Comp ref={ref as any} {...props} /> 
  }
)
Label.displayName = "Label"
export { Label }
