allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

gradle.addProjectEvaluationListener(object : ProjectEvaluationListener {
    override fun beforeEvaluate(project: Project) {}
    override fun afterEvaluate(project: Project, state: ProjectState) {
        if (project == rootProject) return
        val androidExt = project.extensions.findByName("android")
        if (androidExt != null) {
            val method = androidExt.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
            method.invoke(androidExt, 36)
        }
    }
})

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
